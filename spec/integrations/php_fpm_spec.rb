describe 'datadog::php_fpm' do
  expected_yaml = <<-EOF
  logs: ~
  init_config:

  instances:
    - status_url: http://localhost/status
      user: user
      password: mypassword
      tags:
        - optional_tag1
        - optional_tag2
    - ping_url: http://localhost/ping
      ping_reply: pong
      user: user
      password: mypassword
      tags:
        - optional_tag1
        - optional_tag2
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['datadog_monitor']
    ) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }

      node.normal['datadog'] = {
        'api_key' => 'someapikey',
        'php_fpm' => {
          'instances' => [
            {
              'password' => 'mypassword',
              'status_url' => 'http://localhost/status',
              'user' => 'user',
              'tags' => [
                'optional_tag1',
                'optional_tag2'
              ]
            },
            {
              'password' => 'mypassword',
              'ping_url' => 'http://localhost/ping',
              'ping_reply' => 'pong',
              'user' => 'user',
              'tags' => [
                'optional_tag1',
                'optional_tag2'
              ]
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('php_fpm') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/php_fpm.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
