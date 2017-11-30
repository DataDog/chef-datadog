describe 'datadog::cassandra' do
  context 'version 1 (default)' do
    expected_yaml = <<-EOF
      logs: ~
      instances:
        - host: localhost
          port: 7199
          cassandra_aliasing: true
          user: someuser
          password: somepass
          process_name_regex: .*cassandra.*

      init_config:
        conf:
          - include:
              domain: org.apache.cassandra.db
              attribute:
                - BloomFilterDiskSpaceUsed
                - BloomFilterFalsePositives
                - BloomFilterFalseRatio
                - Capacity
                - CompletedTasks
                - CompressionRatio
                - ExceptionCount
                - Hits
                - KeyCacheRecentHitRate
                - LiveDiskSpaceUsed
                - LiveSSTableCount
                - Load
                - MaxRowSize
                - MeanRowSize
                - MemtableColumnsCount
                - MemtableDataSize
                - MemtableSwitchCount
                - MinRowSize
                - PendingTasks
                - ReadCount
                - RecentHitRate
                - RecentRangeLatencyMicros
                - RecentReadLatencyMicros
                - RecentWriteLatencyMicros
                - Requests
                - RowCacheRecentHitRate
                - Size
                - TotalDiskSpaceUsed
                - TotalReadLatencyMicros
                - TotalWriteLatencyMicros
                - UpdateInterval
                - WriteCount
            exclude:
              keyspace: system
          - include:
              domain: org.apache.cassandra.internal
              attribute:
                - ActiveCount
                - CompletedTasks
                - CurrentlyBlockedTasks
                - TotalBlockedTasks
          - include:
              domain: org.apache.cassandra.net
              attribute:
                - TotalTimeouts
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
        node.automatic['languages'] = { python: { version: '2.7.11' } }

        node.set['datadog'] = {
          api_key: 'someapikey',
          cassandra: {
            instances: [
              {
                host: 'localhost',
                port: 7199,
                user: 'someuser',
                password: 'somepass',
                process_name_regex: '.*cassandra.*'
              }
            ],
            init_config: {
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
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('cassandra') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/dd-agent/conf.d/cassandra.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end

  context 'version 2' do
    expected_yaml = <<-EOF
    logs: ~
    instances:
      - host: localhost
        port: 7199
        cassandra_aliasing: true
        user: someuser
        password: somepass
        process_name_regex: .*cassandra.*

    init_config:
      conf:
        - include:
            domain: org.apache.cassandra.metrics
            type: ClientRequest
            scope:
              - Read
              - Write
            name:
              - Latency
              - Timeouts
              - Unavailables
            attribute:
              - Count
              - OneMinuteRate
        - include:
            domain: org.apache.cassandra.metrics
            type: ClientRequest
            scope:
              - Read
              - Write
            name:
              - TotalLatency
        - include:
            domain: org.apache.cassandra.metrics
            type: Storage
            name:
              - Load
              - Exceptions
        - include:
            domain: org.apache.cassandra.metrics
            type: ColumnFamily
            bean_regex:
              - .*keyspace=.*
            name:
              - TotalDiskSpaceUsed
              - BloomFilterDiskSpaceUsed
              - BloomFilterFalsePositives
              - BloomFilterFalseRatio
              - CompressionRatio
              - LiveDiskSpaceUsed
              - LiveSSTableCount
              - MaxRowSize
              - MeanRowSize
              - MemtableColumnsCount
              - MemtableLiveDataSize
              - MemtableSwitchCount
              - MinRowSize
          exclude:
            keyspace:
              - OpsCenter
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: Cache
            name:
              - Capacity
              - Size
            attribute:
              - Value
        - include:
            domain: org.apache.cassandra.metrics
            type: Cache
            name:
              - Hits
              - Requests
            attribute:
              - Count
        - include:
            domain: org.apache.cassandra.metrics
            type: ThreadPools
            path: request
            name:
              - ActiveTasks
              - CompletedTasks
              - PendingTasks
              - CurrentlyBlockedTasks
        - include:
            domain: org.apache.cassandra.db
            attribute:
              - UpdateInterval
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.set['datadog'] = {
          api_key: 'someapikey',
          cassandra: {
            version: 2,
            instances: [
              {
                host: 'localhost',
                port: 7199,
                user: 'someuser',
                password: 'somepass',
                process_name_regex: '.*cassandra.*'
              }
            ],
            init_config: {
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
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('cassandra') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/dd-agent/conf.d/cassandra.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
