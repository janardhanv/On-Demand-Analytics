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

package org.apache.giraph.comm.requests;

import org.apache.giraph.comm.ServerData;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.io.WritableComparable;
import org.apache.log4j.Logger;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * Send a collection of vertex messages for a partition.
 *
 * @param <I> Vertex id
 * @param <V> Vertex data
 * @param <E> Edge data
 * @param <M> Message data
 */
@SuppressWarnings("rawtypes")
public class SendPartitionMessagesRequest<I extends WritableComparable,
    V extends Writable, E extends Writable, M extends Writable> extends
    WritableRequest<I, V, E, M> implements WorkerRequest<I, V, E, M> {
  /** Class logger */
  private static final Logger LOG =
      Logger.getLogger(SendPartitionMessagesRequest.class);
  /** Partition id */
  private int partitionId;
  /** Messages sent for a partition */
  private Map<I, Collection<M>> vertexIdMessages;

  /**
   * Constructor used for reflection only
   */
  public SendPartitionMessagesRequest() { }

  /**
   * Constructor used to send request.
   *
   * @param partitionId Partition to send the request to
   * @param vertexIdMessages Map of messages to send
   */
  public SendPartitionMessagesRequest(int partitionId,
                                      Map<I, Collection<M>> vertexIdMessages) {
    this.partitionId = partitionId;
    this.vertexIdMessages = vertexIdMessages;
  }

  @Override
  public void readFieldsRequest(DataInput input) throws IOException {
    partitionId = input.readInt();
    int vertexIdMessagesSize = input.readInt();
    vertexIdMessages = Maps.newHashMapWithExpectedSize(vertexIdMessagesSize);
    for (int i = 0; i < vertexIdMessagesSize; ++i) {
      I vertexId = getConf().createVertexId();
      vertexId.readFields(input);
      int messageCount = input.readInt();
      List<M> messageList = Lists.newArrayListWithCapacity(messageCount);
      for (int j = 0; j < messageCount; ++j) {
        M message = getConf().createMessageValue();
        message.readFields(input);
        messageList.add(message);
      }
      if (vertexIdMessages.put(vertexId, messageList) != null) {
        throw new IllegalStateException(
            "readFields: Already has vertex id " + vertexId);
      }
    }
  }

  @Override
  public void writeRequest(DataOutput output) throws IOException {
    output.writeInt(partitionId);
    output.writeInt(vertexIdMessages.size());
    for (Entry<I, Collection<M>> entry : vertexIdMessages.entrySet()) {
      entry.getKey().write(output);
      output.writeInt(entry.getValue().size());
      for (M message : entry.getValue()) {
        message.write(output);
      }
    }
  }

  @Override
  public RequestType getType() {
    return RequestType.SEND_PARTITION_MESSAGES_REQUEST;
  }

  @Override
  public void doRequest(ServerData<I, V, E, M> serverData) {
    try {
      serverData.getIncomingMessageStore().addPartitionMessages(
          vertexIdMessages, partitionId);
    } catch (IOException e) {
      throw new RuntimeException("doRequest: Got IOException ", e);
    }
  }

  /**
   * Get id of partition
   *
   * @return Partition id
   */
  public int getPartitionId() {
    return partitionId;
  }

  /**
   * Get messages
   *
   * @return Messages map
   */
  public Map<I, Collection<M>> getVertexIdMessages() {
    return vertexIdMessages;
  }
}
