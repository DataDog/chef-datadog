describe 'datadog::windows_service' do
  expected_yaml = <<-EOF
    instances:
    - host: REMOTEHOSTNAME
      username: REMOTEHOSTNAME\\thomas
      password: secretpw
      services:
        - RemoteService1
        - RemoteService2

    logs: ~
    init_config:

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
        windows_service: {
          instances: [
            {
              username: 'REMOTEHOSTNAME\\thomas',
              services: ['RemoteService1', 'RemoteService2'],
              host: 'REMOTEHOSTNAME',
              password: 'secretpw'
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('windows_service') }

  it 'renders expected YAML config file for remote host service monitoring' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/windows_service.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end

describe 'datadog::windows_service' do
  expected_yaml = <<-EOF
    instances:
    - host: .
      services:
        - LocalService1
        - LocalService2

    init_config:
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
        windows_service: {
          instances: [
            {
              services: ['LocalService1', 'LocalService2'],
              host: '.'
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('windows_service') }

  it 'renders expected YAML config file for local host service monitoring' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/windows_service.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
