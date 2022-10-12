describe 'datadog::kafka_consumer' do
  expected_yaml = <<-EOF
  logs:

  instances:
    - kafka_connect_str: localhost:19092
      consumer_groups:
        my_consumer:
          my_topic: [0, 1, 4, 12]
      monitor_unlisted_consumer_groups: false
      zk_connect_str: localhost:2181
      zk_prefix: /0.8
      kafka_consumer_offsets: true

  init_config:
  # The Kafka Consumer check does not require any init_config
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
        kafka_consumer: {
          instances: [
            {
              kafka_connect_str: 'localhost:19092',
              consumer_groups: {
                my_consumer: {
                  my_topic: [0, 1, 4, 12],
                },
              },
              monitor_unlisted_consumer_groups: false,
              zk_connect_str: 'localhost:2181',
              password: 'localhost:2181',
              zk_prefix: '/0.8',
              kafka_consumer_offsets: true,
            },
          ],
        },
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('kafka_consumer') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/kafka_consumer.d/conf.yaml').with_content do |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    end)
  end
end
