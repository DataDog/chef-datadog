describe 'datadog::kafka' do
  context 'version 1 (default)' do
    expected_yaml = <<-EOF
    logs: ~
    instances:
      - host: localhost
        port: 7199
        name: fasdfas
        user: someuser
        password: somepass
        tags:
          key: value

    init_config:
      is_jmx: true

      # Metrics collected by this check. You should not have to modify this.
      conf:
        #
        # Aggregate cluster stats
        #
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsBytesOutPerSec"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.net.bytes_out
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsBytesInPerSec"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.net.bytes_in
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsMessagesInPerSec"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.messages_in

        #
        # Request timings
        #
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsFailedFetchRequestsPerSec"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.request.fetch.failed
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsFailedProduceRequestsPerSec"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.request.produce.failed
        - include:
            domain: '"kafka.network"'
            bean: '"kafka.network":type="RequestMetrics",name="Produce-TotalTimeMs"'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.produce.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.produce.time.99percentile
        - include:
            domain: '"kafka.network"'
            bean: '"kafka.network":type="RequestMetrics",name="Fetch-TotalTimeMs"'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.fetch.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.fetch.time.99percentile
        - include:
            domain: '"kafka.network"'
            bean: '"kafka.network":type="RequestMetrics",name="UpdateMetadata-TotalTimeMs"'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.update_metadata.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.update_metadata.time.99percentile
        - include:
            domain: '"kafka.network"'
            bean: '"kafka.network":type="RequestMetrics",name="Metadata-TotalTimeMs"'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.metadata.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.metadata.time.99percentile
        - include:
            domain: '"kafka.network"'
            bean: '"kafka.network":type="RequestMetrics",name="Offsets-TotalTimeMs"'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.offsets.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.offsets.time.99percentile

        #
        # Replication stats
        #
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="ReplicaManager",name="ISRShrinksPerSec"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.replication.isr_shrinks
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="ReplicaManager",name="ISRExpandsPerSec"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.replication.isr_expands
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="ControllerStats",name="LeaderElectionRateAndTimeMs"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.replication.leader_elections
        - include:
            domain: '"kafka.server"'
            bean: '"kafka.server":type="ControllerStats",name="UncleanLeaderElectionsPerSec"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.replication.unclean_leader_elections

        #
        # Log flush stats
        #
        - include:
            domain: '"kafka.log"'
            bean: '"kafka.log":type="LogFlushStats",name="LogFlushRateAndTimeMs"'
            attribute:
              MeanRate:
                metric_type: gauge
                alias: kafka.log.flush_rate
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.set['datadog'] = {
          api_key: 'someapikey',
          kafka: {
            instances: [
              {
                host: 'localhost',
                port: 7199,
                name: 'fasdfas',
                user: 'someuser',
                password: 'somepass',
                tags: { key: 'value' }
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('kafka') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/dd-agent/conf.d/kafka.yaml').with_content { |content|
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
              name: fasdfas
              user: someuser
              password: somepass
              tags:
                key: value

    init_config:
      is_jmx: true

      # Metrics collected by this check. You should not have to modify this.
      conf:
        # v0.8.2.x Producers
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=ProducerRequestMetrics,name=ProducerRequestRateAndTimeMs,clientId=.*'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.producer.request_rate
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=ProducerRequestMetrics,name=ProducerRequestRateAndTimeMs,clientId=.*'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.producer.request_latency_avg
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=ProducerTopicMetrics,name=BytesPerSec,clientId=.*'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.producer.bytes_out
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=ProducerTopicMetrics,name=MessagesPerSec,clientId=.*'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.producer.message_rate


        # v0.9.0.x Producers
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=producer-metrics,client-id=.*'
            attribute:
              response-rate:
                metric_type: gauge
                alias: kafka.producer.response_rate
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=producer-metrics,client-id=.*'
            attribute:
              request-rate:
                metric_type: gauge
                alias: kafka.producer.request_rate
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=producer-metrics,client-id=.*'
            attribute:
              request-latency-avg:
                metric_type: gauge
                alias: kafka.producer.request_latency_avg
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=producer-metrics,client-id=.*'
            attribute:
              outgoing-byte-rate:
                metric_type: gauge
                alias: kafka.producer.bytes_out
        - include:
            domain: 'kafka.producer'
            bean_regex: 'kafka\\.producer:type=producer-metrics,client-id=.*'
            attribute:
              io-wait-time-ns-avg:
                metric_type: gauge
                alias: kafka.producer.io_wait


        # v0.8.2.x Consumers
        - include:
            domain: 'kafka.consumer'
            bean_regex: 'kafka\\.consumer:type=ConsumerFetcherManager,name=MaxLag,clientId=.*'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.consumer.max_lag
        - include:
            domain: 'kafka.consumer'
            bean_regex: 'kafka\\.consumer:type=ConsumerFetcherManager,name=MinFetchRate,clientId=.*'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.consumer.fetch_rate
        - include:
            domain: 'kafka.consumer'
            bean_regex: 'kafka\\.consumer:type=ConsumerTopicMetrics,name=BytesPerSec,clientId=.*'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.consumer.bytes_in
        - include:
            domain: 'kafka.consumer'
            bean_regex: 'kafka\\.consumer:type=ConsumerTopicMetrics,name=MessagesPerSec,clientId=.*'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.consumer.messages_in

        # Offsets committed to ZooKeeper
        - include:
            domain: 'kafka.consumer'
            bean_regex: 'kafka\\.consumer:type=ZookeeperConsumerConnector,name=ZooKeeperCommitsPerSec,clientId=.*'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.consumer.zookeeper_commits
        # Offsets committed to Kafka
        - include:
            domain: 'kafka.consumer'
            bean_regex: 'kafka\\.consumer:type=ZookeeperConsumerConnector,name=KafkaCommitsPerSec,clientId=.*'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.consumer.kafka_commits

        # v0.9.0.x Consumers
        - include:
            domain: 'kafka.consumer'
            bean_regex: 'kafka\\.consumer:type=consumer-fetch-manager-metrics,client-id=.*'
            attribute:
              bytes-consumed-rate:
                metric_type: gauge
                alias: kafka.consumer.bytes_in
        - include:
            domain: 'kafka.consumer'
            bean_regex: 'kafka\\.consumer:type=consumer-fetch-manager-metrics,client-id=.*'
            attribute:
              records-consumed-rate:
                metric_type: gauge
                alias: kafka.consumer.messages_in

        #
        # Aggregate cluster stats
        #
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.net.bytes_out.rate
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.net.bytes_in.rate
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.messages_in.rate
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=BrokerTopicMetrics,name=BytesRejectedPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.net.bytes_rejected.rate

        #
        # Request timings
        #
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=BrokerTopicMetrics,name=FailedFetchRequestsPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.request.fetch.failed.rate
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=BrokerTopicMetrics,name=FailedProduceRequestsPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.request.produce.failed.rate
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=RequestsPerSec,request=Produce'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.request.produce.rate
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=TotalTimeMs,request=Produce'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.produce.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.produce.time.99percentile
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=RequestsPerSec,request=FetchConsumer'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.request.fetch_consumer.rate
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=RequestsPerSec,request=FetchFollower'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.request.fetch_follower.rate
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=TotalTimeMs,request=FetchConsumer'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.fetch_consumer.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.fetch_consumer.time.99percentile
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=TotalTimeMs,request=FetchFollower'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.fetch_follower.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.fetch_follower.time.99percentile
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=TotalTimeMs,request=UpdateMetadata'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.update_metadata.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.update_metadata.time.99percentile
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=TotalTimeMs,request=Metadata'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.metadata.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.metadata.time.99percentile
        - include:
            domain: 'kafka.network'
            bean: 'kafka.network:type=RequestMetrics,name=TotalTimeMs,request=Offsets'
            attribute:
              Mean:
                metric_type: gauge
                alias: kafka.request.offsets.time.avg
              99thPercentile:
                metric_type: gauge
                alias: kafka.request.offsets.time.99percentile
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=KafkaRequestHandlerPool,name=RequestHandlerAvgIdlePercent'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.request.handler.avg.idle.pct.rate
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=ProducerRequestPurgatory,name=PurgatorySize'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.request.producer_request_purgatory.size
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=FetchRequestPurgatory,name=PurgatorySize'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.request.fetch_request_purgatory.size

        #
        # Replication stats
        #
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=ReplicaManager,name=UnderReplicatedPartitions'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.replication.under_replicated_partitions
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=ReplicaManager,name=IsrShrinksPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.replication.isr_shrinks.rate
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=ReplicaManager,name=IsrExpandsPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.replication.isr_expands.rate
        - include:
            domain: 'kafka.controller'
            bean: 'kafka.controller:type=ControllerStats,name=LeaderElectionRateAndTimeMs'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.replication.leader_elections.rate
        - include:
            domain: 'kafka.controller'
            bean: 'kafka.controller:type=ControllerStats,name=UncleanLeaderElectionsPerSec'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.replication.unclean_leader_elections.rate
        - include:
            domain: 'kafka.controller'
            bean: 'kafka.controller:type=KafkaController,name=OfflinePartitionsCount'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.replication.offline_partitions_count
        - include:
            domain: 'kafka.controller'
            bean: 'kafka.controller:type=KafkaController,name=ActiveControllerCount'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.replication.active_controller_count
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=ReplicaManager,name=PartitionCount'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.replication.partition_count
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=ReplicaManager,name=LeaderCount'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.replication.leader_count
        - include:
            domain: 'kafka.server'
            bean: 'kafka.server:type=ReplicaFetcherManager,name=MaxLag,clientId=Replica'
            attribute:
              Value:
                metric_type: gauge
                alias: kafka.replication.max_lag

        #
        # Log flush stats
        #
        - include:
            domain: 'kafka.log'
            bean: 'kafka.log:type=LogFlushStats,name=LogFlushRateAndTimeMs'
            attribute:
              Count:
                metric_type: rate
                alias: kafka.log.flush_rate.rate
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.set['datadog'] = {
          api_key: 'someapikey',
          kafka: {
            version: 2,
            instances: [
              {
                host: 'localhost',
                port: 7199,
                name: 'fasdfas',
                user: 'someuser',
                password: 'somepass',
                tags: { key: 'value' }
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('kafka') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/dd-agent/conf.d/kafka.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
