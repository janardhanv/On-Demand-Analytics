/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.giraph.graph;

import org.apache.giraph.GiraphConfiguration;
import org.apache.giraph.ImmutableClassesGiraphConfiguration;
import org.apache.giraph.bsp.BspInputFormat;
import org.apache.giraph.bsp.BspOutputFormat;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.ipc.Client;
import org.apache.hadoop.mapreduce.Job;
import org.apache.log4j.Logger;

import java.io.IOException;

/**
 * Generates an appropriate internal {@link Job} for using Giraph in Hadoop.
 * Uses composition to avoid unwanted {@link Job} methods from exposure
 * to the user.
 */
public class GiraphJob {
  static {
    Configuration.addDefaultResource("giraph-site.xml");
  }

  /** Class logger */
  private static final Logger LOG = Logger.getLogger(GiraphJob.class);
  /** Internal delegated job to proxy interface requests for Job */
  private final DelegatedJob delegatedJob;
  /** Name of the job */
  private final String jobName;
  /** Helper configuration from the job */
  private final GiraphConfiguration giraphConfiguration;

  /**
   * Delegated job that simply passes along the class GiraphConfiguration.
   */
  private class DelegatedJob extends Job {
    /** Ensure that for job initiation the super.getConfiguration() is used */
    private boolean jobInited = false;

    /**
     * Constructor
     *
     * @throws IOException
     */
    DelegatedJob() throws IOException { }

    @Override
    public Configuration getConfiguration() {
      if (jobInited) {
        return giraphConfiguration;
      } else {
        return super.getConfiguration();
      }
    }
  }

  /**
   * Constructor that will instantiate the configuration
   *
   * @param jobName User-defined job name
   * @throws IOException
   */
  public GiraphJob(String jobName) throws IOException {
    this(new GiraphConfiguration(), jobName);
  }

  /**
   * Constructor.
   *
   * @param configuration User-defined configuration
   * @param jobName User-defined job name
   * @throws IOException
   */
  public GiraphJob(Configuration configuration,
                   String jobName) throws IOException {
    this(new GiraphConfiguration(configuration), jobName);
  }

  /**
   * Constructor.
   *
   * @param giraphConfiguration User-defined configuration
   * @param jobName User-defined job name
   * @throws IOException
   */
  public GiraphJob(GiraphConfiguration giraphConfiguration,
                   String jobName) throws IOException {
    this.jobName = jobName;
    this.giraphConfiguration = giraphConfiguration;
    this.delegatedJob = new DelegatedJob();
  }

  /**
   * Get the configuration from the internal job.
   *
   * @return Configuration used by the job.
   */
  public GiraphConfiguration getConfiguration() {
    return giraphConfiguration;
  }

  /**
   * Be very cautious when using this method as it returns the internal job
   * of {@link GiraphJob}.  This should only be used for methods that require
   * access to the actual {@link Job}, i.e. FileInputFormat#addInputPath().
   *
   * @return Internal job that will actually be submitted to Hadoop.
   */
  public Job getInternalJob() {
    delegatedJob.jobInited = true;
    return delegatedJob;
  }
  /**
   * Make sure the configuration is set properly by the user prior to
   * submitting the job.
   *
   * @param conf Configuration to check
   */
  private void checkConfiguration(ImmutableClassesGiraphConfiguration conf) {
    if (conf.getMaxWorkers() < 0) {
      throw new RuntimeException("checkConfiguration: No valid " +
          GiraphConfiguration.MAX_WORKERS);
    }
    if (conf.getMinPercentResponded() <= 0.0f ||
        conf.getMinPercentResponded() > 100.0f) {
      throw new IllegalArgumentException(
          "checkConfiguration: Invalid " + conf.getMinPercentResponded() +
              " for " + GiraphConfiguration.MIN_PERCENT_RESPONDED);
    }
    if (conf.getMinWorkers() < 0) {
      throw new IllegalArgumentException("checkConfiguration: No valid " +
          GiraphConfiguration.MIN_WORKERS);
    }
    if (conf.getVertexClass() == null) {
      throw new IllegalArgumentException("checkConfiguration: Null" +
          GiraphConfiguration.VERTEX_CLASS);
    }
    if (conf.getVertexInputFormatClass() == null) {
      throw new IllegalArgumentException("checkConfiguration: Null " +
          GiraphConfiguration.VERTEX_INPUT_FORMAT_CLASS);
    }
    if (conf.getVertexResolverClass() == null) {
      if (LOG.isInfoEnabled()) {
        LOG.info("checkConfiguration: No class found for " +
            GiraphConfiguration.VERTEX_RESOLVER_CLASS + ", defaulting to " +
            VertexResolver.class.getCanonicalName());
      }
    }
  }


  /**
   * Check if the configuration is local.  If it is local, do additional
   * checks due to the restrictions of LocalJobRunner.
   *
   * @param conf Configuration
   */
  private static void checkLocalJobRunnerConfiguration(
      GiraphConfiguration conf) {
    String jobTracker = conf.get("mapred.job.tracker", null);
    if (!jobTracker.equals("local")) {
      // Nothing to check
      return;
    }

    int maxWorkers = conf.getMaxWorkers();
    if (maxWorkers != 1) {
      throw new IllegalArgumentException(
          "checkLocalJobRunnerConfiguration: When using " +
              "LocalJobRunner, must have only one worker since " +
          "only 1 task at a time!");
    }
    if (conf.getSplitMasterWorker()) {
      throw new IllegalArgumentException(
          "checkLocalJobRunnerConfiguration: When using " +
              "LocalJobRunner, you cannot run in split master / worker " +
          "mode since there is only 1 task at a time!");
    }
  }

  /**
   * Check whether a specified int conf value is set and if not, set it.
   *
   * @param param Conf value to check
   * @param defaultValue Assign to value if not set
   */
  private void setIntConfIfDefault(String param, int defaultValue) {
    if (giraphConfiguration.getInt(param, Integer.MIN_VALUE) ==
        Integer.MIN_VALUE) {
      giraphConfiguration.setInt(param, defaultValue);
    }
  }

  /**
   * Runs the actual graph application through Hadoop Map-Reduce.
   *
   * @param verbose If true, provide verbose output, false otherwise
   * @return True if success, false otherwise
   * @throws ClassNotFoundException
   * @throws InterruptedException
   * @throws IOException
   */
  public final boolean run(boolean verbose)
    throws IOException, InterruptedException, ClassNotFoundException {
    // Most users won't hit this hopefully and can set it higher if desired
    setIntConfIfDefault("mapreduce.job.counters.limit", 512);

    // Capacity scheduler-specific settings.  These should be enough for
    // a reasonable Giraph job
    setIntConfIfDefault("mapred.job.map.memory.mb", 1024);
    setIntConfIfDefault("mapred.job.reduce.memory.mb", 1024);

    // Speculative execution doesn't make sense for Giraph
    giraphConfiguration.setBoolean(
        "mapred.map.tasks.speculative.execution", false);

    // Set the ping interval to 5 minutes instead of one minute
    // (DEFAULT_PING_INTERVAL)
    Client.setPingInterval(giraphConfiguration, 60000 * 5);

    // Should work in MAPREDUCE-1938 to let the user jars/classes
    // get loaded first
    giraphConfiguration.setBoolean("mapreduce.user.classpath.first", true);

    // Set the job properties, check them, and submit the job
    ImmutableClassesGiraphConfiguration immutableClassesGiraphConfiguration =
        new ImmutableClassesGiraphConfiguration(giraphConfiguration);
    checkConfiguration(immutableClassesGiraphConfiguration);
    checkLocalJobRunnerConfiguration(immutableClassesGiraphConfiguration);
    Job submittedJob = new Job(immutableClassesGiraphConfiguration, jobName);
    if (submittedJob.getJar() == null) {
      submittedJob.setJarByClass(GiraphJob.class);
    }
    submittedJob.setNumReduceTasks(0);
    submittedJob.setMapperClass(GraphMapper.class);
    submittedJob.setInputFormatClass(BspInputFormat.class);
    submittedJob.setOutputFormatClass(BspOutputFormat.class);
    return submittedJob.waitForCompletion(verbose);
  }
}
