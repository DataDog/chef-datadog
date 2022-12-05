# Copyright:: 2011-Present, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Encoding: utf-8

require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/cassandra.d/conf.yaml')

describe service(@agent_service_name) do
  it { should be_running }
end

describe file(AGENT_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(AGENT_CONFIG)

    expected = {
      'instances' => [
        {
          host: 'localhost',
          port: 7199,
          user: 'someuser',
          password: 'somepass',
          process_name_regex: '.*cassandra.*',
          cassandra_aliasing: true
        }
      ],
      'logs' => nil,
      'init_config' => {
        conf: [
          {
            include: {
              domain: 'org.apache.cassandra.db',
              attribute: %w[
                BloomFilterDiskSpaceUsed
                BloomFilterFalsePositives
                BloomFilterFalseRatio
                Capacity
                CompletedTasks
                CompressionRatio
                ExceptionCount
                Hits
                KeyCacheRecentHitRate
                LiveDiskSpaceUsed
                LiveSSTableCount
                Load
                MaxRowSize
                MeanRowSize
                MemtableColumnsCount
                MemtableDataSize
                MemtableSwitchCount
                MinRowSize
                PendingTasks
                ReadCount
                RecentHitRate
                RecentRangeLatencyMicros
                RecentReadLatencyMicros
                RecentWriteLatencyMicros
                Requests
                RowCacheRecentHitRate
                Size
                TotalDiskSpaceUsed
                TotalReadLatencyMicros
                TotalWriteLatencyMicros
                UpdateInterval
                WriteCount
              ]
            },
            exclude: {
              keyspace: 'system'
            }
          },
          {
            include: {
              domain: 'org.apache.cassandra.internal',
              attribute: [
                'ActiveCount',
                'CompletedTasks',
                'CurrentlyBlockedTasks',
                'TotalBlockedTasks'
              ]
            }
          },
          {
            include: {
              domain: 'org.apache.cassandra.net',
              attribute: [
                'TotalTimeouts'
              ]
            }
          }
        ]
      }
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
