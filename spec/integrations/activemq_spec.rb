describe 'datadog::activemq' do
  expected_yaml = <<-EOF
    logs: ~
    instances:
    - host: localhost
      port: 1099
      user: someuser
      password: somepass
      name: activemq_instance
    init_config:
      conf:
        - include:
            Type: Queue
            attribute:
              AverageEnqueueTime:
                alias: activemq.queue.avg_enqueue_time
                metric_type: gauge
              ConsumerCount:
                alias: activemq.queue.consumer_count
                metric_type: gauge
              ProducerCount:
                alias: activemq.queue.producer_count
                metric_type: gauge
              MaxEnqueueTime:
                alias: activemq.queue.max_enqueue_time
                metric_type: gauge
              MinEnqueueTime:
                alias: activemq.queue.min_enqueue_time
                metric_type: gauge
              MemoryPercentUsage:
                alias: activemq.queue.memory_pct
                metric_type: gauge
              QueueSize:
                alias: activemq.queue.size
                metric_type: gauge
              DequeueCount:
                alias: activemq.queue.dequeue_count
                metric_type: counter
              DispatchCount:
                alias: activemq.queue.dispatch_count
                metric_type: counter
              EnqueueCount:
                alias: activemq.queue.enqueue_count
                metric_type: counter
              ExpiredCount:
                alias: activemq.queue.expired_count
                metric_type: counter
              InFlightCount:
                alias: activemq.queue.in_flight_count
                metric_type: counter

        - include:
            Type: Broker
            attribute:
              StorePercentUsage:
                alias: activemq.broker.store_pct
                metric_type: gauge
              TempPercentUsage:
                alias: activemq.broker.temp_pct
                metric_type: gauge
              MemoryPercentUsage:
                alias: activemq.broker.memory_pct
                metric_type: gauge
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
        activemq: {
          instances: [
            {
              host: 'localhost',
              name: 'activemq_instance',
              password: 'somepass',
              port: 1099,
              user: 'someuser'
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('activemq') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/activemq.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
