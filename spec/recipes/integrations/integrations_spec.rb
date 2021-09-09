describe 'datadog::integrations' do
  expected_yaml = <<-EOF
    instances:
    - url: 'http://localhost:22222'
    init_config: ~
    logs: ~
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
        extra_packages: {
          twemproxy: {
            name: 'dd-check-twemproxy',
            version: '0.1.0-1'
          }
        },
        twemproxy: {
          instances: [
            {
              url: 'http://localhost:22222'
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it { is_expected.to add_datadog_monitor('twemproxy') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/twemproxy.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end

  it 'installs check\'s package with specified version' do
    expect(chef_run).to install_package('dd-check-twemproxy').with_version('0.1.0-1')
  end
end
