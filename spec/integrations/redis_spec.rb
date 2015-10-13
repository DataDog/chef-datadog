describe 'datadog::redisdb' do
  expected_yaml = <<-EOF
  init_config:

  instances:
    - host: localhost
      port: 6379
      db: 0
      password: mypassword
      socket_timeout: 5
      tags:
        - optional_tag1
        - optional_tag2
      keys:
        - key1
        - key2
      warn_on_missing_keys: True
      slowlog-max-len: 128
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }

      node.set['datadog'] = {
        'api_key' => 'someapikey',
        'redisdb' => {
          'instances' => [
            {
              'db' => 0,
              'keys' => ['key1', 'key2'],
              'port' => 6379,
              'password' => 'mypassword',
              'server' => 'localhost',
              'slowlog-max-len' => 128,
              'socket_timeout' => 5,
              'tags' => [
                'optional_tag1',
                'optional_tag2'
              ],
              'warn_on_missing_keys' => true
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
    expect(chef_run).to render_file('/etc/dd-agent/conf.d/redisdb.yaml').with_content { |content|
      expect(YAML.load(content).to_json).to be_json_eql(YAML.load(expected_yaml).to_json)
    }
  end
end
