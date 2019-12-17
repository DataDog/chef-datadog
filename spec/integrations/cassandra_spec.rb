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
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.11' } }

        node.normal['datadog'] = {
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
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/cassandra.d/conf.yaml').with_content { |content|
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
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.normal['datadog'] = {
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
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/cassandra.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end

  context 'version 3' do
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
            name:
              - Latency
            attribute:
              - 75thPercentile
              - 95thPercentile
              - OneMinuteRate
        - include:
            domain: org.apache.cassandra.metrics
            type: DroppedMessage
            name:
              - Dropped
            attribute:
              - OneMinuteRate
        - include:
            domain: org.apache.cassandra.metrics
            type: ThreadPools
            scope:
              - MutationStage
              - CounterMutationStage
              - ReadStage
              - ViewMutationStage
            name:
              - PendingTasks
              - CurrentlyBlockedTasks
            path:
              - request
        - include:
            domain: org.apache.cassandra.metrics
            type: ThreadPools
            scope:
              - MemtableFlushWriter
              - HintsDispatcher
              - MemtablePostFlush
              - MigrationStage
              - MiscStage
              - SecondaryIndexManagement
            name:
              - PendingTasks
              - CurrentlyBlockedTasks
            path:
              - internal
        - include:
            domain: org.apache.cassandra.metrics
            type: Storage
            name:
              - Load
              - Exceptions
        - include:
            domain: org.apache.cassandra.metrics
            type: Table
            bean_regex:
              - .*keyspace=.*
            name:
              - ReadLatency
              - WriteLatency
            attribute:
              - 75thPercentile
              - 95thPercentile
              - 99thPercentile
              - OneMinuteRate
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: Table
            bean_regex:
              - .*keyspace=.*
            name:
              - RangeLatency
              - CasPrepareLatency
              - CasProposeLatency
              - CasCommitLatency
              - ViewLockAcquireTime
              - ViewReadTime
            attribute:
              - 75thPercentile
              - 95thPercentile
              - OneMinuteRate
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: Table
            bean_regex:
              - .*keyspace=.*
            name:
              - SSTablesPerReadHistogram
              - TombstoneScannedHistogram
              - WaitingOnFreeMemtableSpace
            attribute:
              - 75thPercentile
              - 95thPercentile
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: Table
            bean_regex:
              - .*keyspace=.*
            name:
              - ColUpdateTimeDeltaHistogram
            attribute:
              - Min
              - 75thPercentile
              - 95thPercentile
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: Table
            bean_regex:
              - .*keyspace=.*
            name:
              - BloomFilterFalseRatio
              - CompressionRatio
              - KeyCacheHitRate
              - LiveSSTableCount
              - MaxPartitionSize
              - MeanPartitionSize
              - MeanRowSize
              - MaxRowSize
              - PendingCompactions
              - SnapshotsSize
            attribute:
              - Value
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: Table
            bean_regex:
              - .*keyspace=.*
            name:
              - CompactionBytesWritten
              - BytesFlushed
              - PendingFlushes
              - LiveDiskSpaceUsed
              - TotalDiskSpaceUsed
              - RowCacheHitOutOfRange
              - RowCacheHit
              - RowCacheMiss
            attribute:
              - Count
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: Cache
            scope: KeyCache
            name:
              - HitRate
            attribute:
              - Count
        - include:
            domain: org.apache.cassandra.metrics
            type: CommitLog
            name:
              - PendingTasks
              - TotalCommitLogSize
            attribute:
              - Value
        - include:
            domain: org.apache.cassandra.db
            type: Tables
            attribute:
              DroppableTombstoneRatio:
                alias: cassandra.db.droppable_tombstone_ratio
        # Young Gen Collectors (Minor Collections)
        - include:
            domain: java.lang
            type: GarbageCollector
            name: Copy
            attribute:
              CollectionCount:
                metric_type: counter
                alias: jmx.gc.minor_collection_count
              CollectionTime:
                metric_type: counter
                alias: jmx.gc.minor_collection_time
        - include:
            domain: java.lang
            type: GarbageCollector
            name: PS Scavenge
            attribute:
              CollectionCount:
                metric_type: counter
                alias: jmx.gc.minor_collection_count
              CollectionTime:
                metric_type: counter
                alias: jmx.gc.minor_collection_time
        - include:
            domain: java.lang
            type: GarbageCollector
            name: ParNew
            attribute:
              CollectionCount:
                metric_type: counter
                alias: jmx.gc.minor_collection_count
              CollectionTime:
                metric_type: counter
                alias: jmx.gc.minor_collection_time
        - include:
            domain: java.lang
            type: GarbageCollector
            name: G1 Young Generation
            attribute:
              CollectionCount:
                metric_type: counter
                alias: jmx.gc.minor_collection_count
              CollectionTime:
                metric_type: counter
                alias: jmx.gc.minor_collection_time
        # Old Gen Collectors (Major collections)
        - include:
            domain: java.lang
            type: GarbageCollector
            name: MarkSweepCompact
            attribute:
              CollectionCount:
                metric_type: counter
                alias: jmx.gc.major_collection_count
              CollectionTime:
                metric_type: counter
                alias: jmx.gc.major_collection_time
        - include:
            domain: java.lang
            type: GarbageCollector
            name: PS MarkSweep
            attribute:
              CollectionCount:
                metric_type: counter
                alias: jmx.gc.major_collection_count
              CollectionTime:
                metric_type: counter
                alias: jmx.gc.major_collection_time
        - include:
            domain: java.lang
            type: GarbageCollector
            name: ConcurrentMarkSweep
            attribute:
              CollectionCount:
                metric_type: counter
                alias: jmx.gc.major_collection_count
              CollectionTime:
                metric_type: counter
                alias: jmx.gc.major_collection_time
        - include:
            domain: java.lang
            type: GarbageCollector
            name: G1 Mixed Generation
            attribute:
              CollectionCount:
                metric_type: counter
                alias: jmx.gc.major_collection_count
              CollectionTime:
                metric_type: counter
                alias: jmx.gc.major_collection_time

        - include:
            domain: org.apache.cassandra.metrics
            type: ColumnFamily
            bean_regex:
              - .*keyspace=.*
            name:
              - ReadLatency
              - WriteLatency
            attribute:
              - 75thPercentile
              - 95thPercentile
              - 99thPercentile
              - OneMinuteRate
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: ColumnFamily
            bean_regex:
              - .*keyspace=.*
            name:
              - RangeLatency
              - CasPrepareLatency
              - CasProposeLatency
              - CasCommitLatency
              - ViewLockAcquireTime
              - ViewReadTime
            attribute:
              - 75thPercentile
              - 95thPercentile
              - OneMinuteRate
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: ColumnFamily
            bean_regex:
              - .*keyspace=.*
            name:
              - SSTablesPerReadHistogram
              - TombstoneScannedHistogram
              - WaitingOnFreeMemtableSpace
            attribute:
              - 75thPercentile
              - 95thPercentile
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: ColumnFamily
            bean_regex:
              - .*keyspace=.*
            name:
              - ColUpdateTimeDeltaHistogram
            attribute:
              - Min
              - 75thPercentile
              - 95thPercentile
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: ColumnFamily
            bean_regex:
              - .*keyspace=.*
            name:
              - BloomFilterFalseRatio
              - CompressionRatio
              - KeyCacheHitRate
              - LiveSSTableCount
              - MaxPartitionSize
              - MeanPartitionSize
              - MeanRowSize
              - MaxRowSize
              - PendingCompactions
              - SnapshotsSize
            attribute:
              - Value
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.metrics
            type: ColumnFamily
            bean_regex:
              - .*keyspace=.*
            name:
              - PendingFlushes
              - LiveDiskSpaceUsed
              - TotalDiskSpaceUsed
              - RowCacheHitOutOfRange
              - RowCacheHit
              - RowCacheMiss
            attribute:
              - Count
          exclude:
            keyspace:
              - system
              - system_auth
              - system_distributed
              - system_schema
              - system_traces
        - include:
            domain: org.apache.cassandra.db
            type: ColumnFamilies
            attribute:
              DroppableTombstoneRatio:
                alias: cassandra.db.droppable_tombstone_ratio
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.normal['datadog'] = {
          api_key: 'someapikey',
          cassandra: {
            version: 3,
            instances: [
              {
                host: 'localhost',
                port: 7199,
                user: 'someuser',
                password: 'somepass',
                process_name_regex: '.*cassandra.*'
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('cassandra') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/cassandra.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
