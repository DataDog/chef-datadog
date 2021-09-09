describe 'datadog::redisdb' do
  expected_yaml = <<-EOF
    logs: ~
    init_config:

    instances:
      - host: localhost
        port: 6379
        db: 0
        password: somepass
        socket_timeout: 5
        tags:
          - optional_tag1
          - optional_tag2
        keys:
          - key1
          - key2
        warn_on_missing_keys: False
        slowlog-max-len: 128
        command_stats: True
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
        redisdb: {
          instances: [
            {
              command_stats: true,
              db: 0,
              keys: ['key1', 'key2'],
              port: 6379,
              password: 'somepass',
              server: 'localhost',
              'slowlog-max-len' => 128,
              socket_timeout: 5,
              tags: [
                'optional_tag1',
                'optional_tag2'
              ],
              warn_on_missing_keys: false
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('redisdb') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/redisdb.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
