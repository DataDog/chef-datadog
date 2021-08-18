describe 'datadog::nginx' do
  expected_yaml = <<-EOF
    logs: ~
    init_config:

    instances:
      - nginx_status_url: http://localhost:80/nginx_status/
        tags:
        - optional_tag1
        - optional_tag2
      - nginx_status_url: http://localhost:81/nginx_status/
        user: my_username
        password: my_password
      - nginx_status_url: https://localhost:82/nginx_status/
        ssl_validation: false
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['datadog_monitor']
    ) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
      node.normal['datadog'] = {
        api_key: 'someapikey',
        nginx: {
          instances: [
            {
              nginx_status_url: 'http://localhost:80/nginx_status/',
              tags: ['optional_tag1', 'optional_tag2']
            }, {
              nginx_status_url: 'http://localhost:81/nginx_status/',
              user: 'my_username',
              password: 'my_password'
            }, {
              nginx_status_url: 'https://localhost:82/nginx_status/',
              ssl_validation: false
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('nginx') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/nginx.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
