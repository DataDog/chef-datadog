describe 'datadog::mesos_slave' do
  expected_yaml = <<-EOF
    instances:
      - url: "http://localhost:5051"
    init_config:
      default_timeout: 10
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.automatic['languages'] = { python: { version: '2.7.2' } }

      node.set['datadog'] = {
        api_key: 'someapikey',
        mesos_slave: {
          instances: [
            {
              url: 'http://localhost:5051'
            }
          ],
          init_config: {
            default_timeout: 10
          }
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('mesos_slave') }

  it 'renders expected YAML config file' do
    expect(chef_run).to render_file('/etc/dd-agent/conf.d/mesos_slave.yaml').with_content { |content|
      expect(YAML.load(content).to_json).to be_json_eql(YAML.load(expected_yaml).to_json)
    }
  end
end
