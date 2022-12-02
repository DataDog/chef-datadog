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
          cassandra_aliasing: true,
        },
      ],
      'logs' => nil,
      'init_config' => {
        conf: [
          {
            include: {
              domain: 'org.apache.cassandra.metrics',
              type: 'ClientRequest',
              scope: %w(
                Read
                Write
              ),
              name: %w(
                Latency
                Timeouts
                Unavailables
              ),
              attribute: %w(
                Count
                OneMinuteRate
              ),
            },
          },
          {
            include: {
              domain: 'org.apache.cassandra.metrics',
              type: 'ClientRequest',
              scope: %w(
                Read
                Write
              ),
              name: [
                'TotalLatency',
              ],
            },
          },
          {
            include: {
              domain: 'org.apache.cassandra.metrics',
              type: 'Storage',
              name: %w(
                Load
                Exceptions
              ),
            },
          },
          {
            include: {
              domain: 'org.apache.cassandra.metrics',
              type: 'ColumnFamily',
              name: %w(
                TotalDiskSpaceUsed
                BloomFilterDiskSpaceUsed
                BloomFilterFalsePositives
                BloomFilterFalseRatio
                CompressionRatio
                LiveDiskSpaceUsed
                LiveSSTableCount
                MaxRowSize
                MeanRowSize
                MemtableColumnsCount
                MemtableLiveDataSize
                MemtableSwitchCount
                MinRowSize
              ),
            },
            exclude: {
              keyspace: %w(
                system
                system_auth
                system_distributed
                system_traces
              ),
            },
          },
          {
            include: {
              domain: 'org.apache.cassandra.metrics',
              type: 'Cache',
              name: %w(
                Capacity
                Size
              ),
              attribute: [
                'Value',
              ],
            },
          },
          {
            include: {
              domain: 'org.apache.cassandra.metrics',
              type: 'Cache',
              name: %w(
                Hits
                Requests
              ),
              attribute: [
                'Count',
              ],
            },
          },
          {
            include: {
              domain: 'org.apache.cassandra.metrics',
              type: 'ThreadPools',
              path: 'request',
              name: %w(
                ActiveTasks
                CompletedTasks
                PendingTasks
                CurrentlyBlockedTasks
              ),
            },
          },
          {
            include: {
              domain: 'org.apache.cassandra.db',
              attribute: [
                'UpdateInterval',
              ],
            },
          },
        ],
      },
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
