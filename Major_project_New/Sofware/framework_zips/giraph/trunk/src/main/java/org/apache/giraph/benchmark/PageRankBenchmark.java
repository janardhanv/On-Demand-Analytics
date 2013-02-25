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

package org.apache.giraph.benchmark;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;
import org.apache.giraph.GiraphConfiguration;
import org.apache.giraph.examples.DoubleSumCombiner;
import org.apache.giraph.graph.GiraphJob;
import org.apache.giraph.io.PseudoRandomVertexInputFormat;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.util.Tool;
import org.apache.hadoop.util.ToolRunner;
import org.apache.log4j.Logger;

/**
 * Default Pregel-style PageRank computation.
 */
public class PageRankBenchmark implements Tool {
  /** Class logger */
  private static final Logger LOG = Logger.getLogger(PageRankBenchmark.class);
  /** Configuration from Configurable */
  private Configuration conf;

  @Override
  public Configuration getConf() {
    return conf;
  }

  @Override
  public void setConf(Configuration conf) {
    this.conf = conf;
  }

  @Override
  public final int run(final String[] args) throws Exception {
    Options options = new Options();
    options.addOption("h", "help", false, "Help");
    options.addOption("v", "verbose", false, "Verbose");
    options.addOption("w",
        "workers",
        true,
        "Number of workers");
    options.addOption("s",
        "supersteps",
        true,
        "Supersteps to execute before finishing");
    options.addOption("V",
        "aggregateVertices",
        true,
        "Aggregate vertices");
    options.addOption("e",
        "edgesPerVertex",
        true,
        "Edges per vertex");
    options.addOption("c",
        "vertexClass",
        true,
        "Vertex class (0 for HashMapVertex, 1 for EdgeListVertex)");
    options.addOption("N",
        "name",
        true,
        "Name of the job");
    options.addOption("nc",
        "noCombiner",
        false,
        "Don't use a combiner");

    HelpFormatter formatter = new HelpFormatter();
    if (args.length == 0) {
      formatter.printHelp(getClass().getName(), options, true);
      return 0;
    }
    CommandLineParser parser = new PosixParser();
    CommandLine cmd = parser.parse(options, args);
    if (cmd.hasOption('h')) {
      formatter.printHelp(getClass().getName(), options, true);
      return 0;
    }
    if (!cmd.hasOption('w')) {
      LOG.info("Need to choose the number of workers (-w)");
      return -1;
    }
    if (!cmd.hasOption('s')) {
      LOG.info("Need to set the number of supersteps (-s)");
      return -1;
    }
    if (!cmd.hasOption('V')) {
      LOG.info("Need to set the aggregate vertices (-V)");
      return -1;
    }
    if (!cmd.hasOption('e')) {
      LOG.info("Need to set the number of edges " +
          "per vertex (-e)");
      return -1;
    }

    int workers = Integer.parseInt(cmd.getOptionValue('w'));
    String name = getClass().getName();
    if (cmd.hasOption("N")) {
      name = name + " " + cmd.getOptionValue("N");
    }

    GiraphJob job = new GiraphJob(getConf(), name);
    if (!cmd.hasOption('c') ||
        (Integer.parseInt(cmd.getOptionValue('c')) == 1)) {
      job.getConfiguration().setVertexClass(
          EdgeListVertexPageRankBenchmark.class);
    } else {
      job.getConfiguration().setVertexClass(
          HashMapVertexPageRankBenchmark.class);
    }
    LOG.info("Using class " +
        job.getConfiguration().get(GiraphConfiguration.VERTEX_CLASS));
    if (!cmd.hasOption("nc")) {
      job.getConfiguration().setVertexCombinerClass(DoubleSumCombiner.class);
    }
    job.getConfiguration().setVertexInputFormatClass(
        PseudoRandomVertexInputFormat.class);
    job.getConfiguration().setWorkerConfiguration(workers, workers, 100.0f);
    job.getConfiguration().setLong(
        PseudoRandomVertexInputFormat.AGGREGATE_VERTICES,
        Long.parseLong(cmd.getOptionValue('V')));
    job.getConfiguration().setLong(
        PseudoRandomVertexInputFormat.EDGES_PER_VERTEX,
        Long.parseLong(cmd.getOptionValue('e')));
    job.getConfiguration().setInt(
        PageRankComputation.SUPERSTEP_COUNT,
        Integer.parseInt(cmd.getOptionValue('s')));

    boolean isVerbose = false;
    if (cmd.hasOption('v')) {
      isVerbose = true;
    }
    if (cmd.hasOption('s')) {
      job.getConfiguration().setInt(
          PageRankComputation.SUPERSTEP_COUNT,
          Integer.parseInt(cmd.getOptionValue('s')));
    }
    if (job.run(isVerbose)) {
      return 0;
    } else {
      return -1;
    }
  }

  /**
   * Execute the benchmark.
   *
   * @param args Typically the command line arguments.
   * @throws Exception Any exception from the computation.
   */
  public static void main(final String[] args) throws Exception {
    System.exit(ToolRunner.run(new PageRankBenchmark(), args));
  }
}
