# Encoding: utf-8
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = '/etc/dd-agent/conf.d/cassandra.yaml'

describe service('datadog-agent') do
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
          process_name_regex: '.*cassandra.*'
        }
      ],
      'init_config' => {
        conf: [
          {
            include: {
              domain: 'org.apache.cassandra.db',
              attribute: [
                'BloomFilterDiskSpaceUsed',
                'BloomFilterFalsePositives',
                'BloomFilterFalseRatio',
                'Capacity',
                'CompletedTasks',
                'CompressionRatio',
                'ExceptionCount',
                'Hits',
                'KeyCacheRecentHitRate',
                'LiveDiskSpaceUsed',
                'LiveSSTableCount',
                'Load',
                'MaxRowSize',
                'MeanRowSize',
                'MemtableColumnsCount',
                'MemtableDataSize',
                'MemtableSwitchCount',
                'MinRowSize',
                'PendingTasks',
                'ReadCount',
                'RecentHitRate',
                'RecentRangeLatencyMicros',
                'RecentReadLatencyMicros',
                'RecentWriteLatencyMicros',
                'Requests',
                'RowCacheRecentHitRate',
                'Size',
                'TotalDiskSpaceUsed',
                'TotalReadLatencyMicros',
                'TotalWriteLatencyMicros',
                'UpdateInterval',
                'WriteCount'
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
