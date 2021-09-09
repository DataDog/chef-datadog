describe 'datadog::mesos_slave' do
  expected_yaml = <<-EOF
    logs: ~
    init_config:
      default_timeout: 10
    instances:
    - url: 'localhost:5050'
      timeout: 8,
      tags:
        - slave
        - tata
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
        mesos_slave: {
          init_config: {
            default_timeout: 10
          },
          instances: [
            {
              url: 'localhost:5050',
              timeout: 8,
              tags: ['slave', 'tata']
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('mesos_slave') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/mesos_slave.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
