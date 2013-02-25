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

package org.apache.giraph.comm.netty.handler;

import org.apache.giraph.GiraphConfiguration;
import org.apache.giraph.comm.requests.WritableRequest;
import org.apache.giraph.utils.SystemTime;
import org.apache.hadoop.conf.Configuration;
import org.apache.log4j.Logger;
import org.jboss.netty.buffer.ChannelBuffer;
import org.jboss.netty.buffer.ChannelBuffers;
import org.jboss.netty.channel.ChannelHandlerContext;
import org.jboss.netty.channel.ChannelStateEvent;
import org.jboss.netty.channel.ExceptionEvent;
import org.jboss.netty.channel.MessageEvent;
import org.jboss.netty.channel.SimpleChannelUpstreamHandler;

/**
 * Generic handler of requests.
 *
 * @param <R> Request type
 */
public abstract class RequestServerHandler<R> extends
    SimpleChannelUpstreamHandler {
  /** Number of bytes in the encoded response */
  public static final int RESPONSE_BYTES = 13;
  /** Class logger */
  private static final Logger LOG =
      Logger.getLogger(RequestServerHandler.class);
  /** Already closed first request? */
  private static volatile boolean ALREADY_CLOSED_FIRST_REQUEST = false;
  /** Close connection on first request (used for simulating failure) */
  private final boolean closeFirstRequest;
  /** Request reserved map (for exactly one semantics) */
  private final WorkerRequestReservedMap workerRequestReservedMap;
  /** My worker id */
  private final int myWorkerId;
  /** Start nanoseconds for the processing time */
  private long startProcessingNanoseconds = -1;

  /**
   * Constructor
   *
   * @param workerRequestReservedMap Worker request reservation map
   * @param conf Configuration
   */
  public RequestServerHandler(
      WorkerRequestReservedMap workerRequestReservedMap,
      Configuration conf) {
    this.workerRequestReservedMap = workerRequestReservedMap;
    closeFirstRequest = conf.getBoolean(
        GiraphConfiguration.NETTY_SIMULATE_FIRST_REQUEST_CLOSED,
        GiraphConfiguration.NETTY_SIMULATE_FIRST_REQUEST_CLOSED_DEFAULT);
    myWorkerId = conf.getInt("mapred.task.partition", -1);
  }

  @Override
  public void messageReceived(
      ChannelHandlerContext ctx, MessageEvent e) {
    if (LOG.isTraceEnabled()) {
      LOG.trace("messageReceived: Got " + e.getMessage().getClass());
    }

    WritableRequest writableRequest = (WritableRequest) e.getMessage();

    // Simulate a closed connection on the first request (if desired)
    if (closeFirstRequest && !ALREADY_CLOSED_FIRST_REQUEST) {
      LOG.info("messageReceived: Simulating closing channel on first " +
          "request " + writableRequest.getRequestId() + " from " +
          writableRequest.getClientId());
      ALREADY_CLOSED_FIRST_REQUEST = true;
      ctx.getChannel().close();
      return;
    }

    // Only execute this request exactly once
    int alreadyDone = 1;
    if (workerRequestReservedMap.reserveRequest(
        writableRequest.getClientId(),
        writableRequest.getRequestId())) {
      if (LOG.isDebugEnabled()) {
        startProcessingNanoseconds = SystemTime.getInstance().getNanoseconds();
      }
      processRequest((R) writableRequest);
      if (LOG.isDebugEnabled()) {
        LOG.debug("messageReceived: Processing client " +
            writableRequest.getClientId() + ", " +
            "requestId " + writableRequest.getRequestId() +
            ", " +  writableRequest.getType() + " took " +
            SystemTime.getInstance().getNanosecondsSince(
                startProcessingNanoseconds) + " ns");
      }
      alreadyDone = 0;
    } else {
      LOG.info("messageReceived: Request id " +
          writableRequest.getRequestId() + " from client " +
          writableRequest.getClientId() +
          " was already processed, " +
          "not processing again.");
    }

    // Send the response with the request id
    ChannelBuffer buffer = ChannelBuffers.directBuffer(RESPONSE_BYTES);
    buffer.writeInt(myWorkerId);
    buffer.writeLong(writableRequest.getRequestId());
    buffer.writeByte(alreadyDone);
    e.getChannel().write(buffer);
  }

  /**
   * Process request
   *
   * @param request Request to process
   */
  public abstract void processRequest(R request);

  @Override
  public void channelConnected(ChannelHandlerContext ctx,
                               ChannelStateEvent e) throws Exception {
    if (LOG.isDebugEnabled()) {
      LOG.debug("channelConnected: Connected the channel on " +
          ctx.getChannel().getRemoteAddress());
    }
  }

  @Override
  public void channelClosed(ChannelHandlerContext ctx,
                            ChannelStateEvent e) throws Exception {
    if (LOG.isDebugEnabled()) {
      LOG.debug("channelClosed: Closed the channel on " +
          ctx.getChannel().getRemoteAddress() + " with event " +
          e);
    }
  }

  @Override
  public void exceptionCaught(ChannelHandlerContext ctx, ExceptionEvent e) {
    LOG.warn("exceptionCaught: Channel failed with " +
        "remote address " + ctx.getChannel().getRemoteAddress(), e.getCause());
  }

  /**
   * Factory for {@link RequestServerHandler}
   */
  public interface Factory {
    /**
     * Create new {@link RequestServerHandler}
     *
     * @param workerRequestReservedMap Worker request reservation map
     * @param conf Configuration to use
     * @return New {@link RequestServerHandler}
     */
    RequestServerHandler newHandler(
        WorkerRequestReservedMap workerRequestReservedMap,
        Configuration conf);
  }
}
