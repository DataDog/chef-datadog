describe 'datadog::nginx' do
  expected_yaml = <<-EOF
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
    ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
      node.set['datadog'] = {
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
    expect(chef_run).to render_file('/etc/dd-agent/conf.d/nginx.yaml').with_content { |content|
      expect(YAML.load(content).to_json).to be_json_eql(YAML.load(expected_yaml).to_json)
    }
  end
end
