describe 'datadog::win32_event_log' do
  expected_yaml = <<-EOF
  init_config:
    tag_event_id: yes

  logs: ~
  instances:
    - log_file:
        - Application
      source_name:
        - MSSQLSERVER
      type:
        - Warning
        - Error
      message_filters:
        - "%error%"
      tags:
        - sqlserver
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
        win32_event_log: {
          init_config: {
            tag_event_id: true
          },
          instances: [
            {
              log_file: ['Application'],
              source_name: ['MSSQLSERVER'],
              type: ['Warning', 'Error'],
              message_filters: ['%error%'],
              tags: ['sqlserver']
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('win32_event_log') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/win32_event_log.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
