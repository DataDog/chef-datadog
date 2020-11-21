describe 'datadog::systemd' do
  expected_yaml = <<-EOF
    ---
    logs:


    instances:
      - unit_names:
          - myservice1.service
          - myservice2.service

        substate_status_mapping:
          myservice1.service:
            running: ok
            exited: critical
          myservice2.service:
            plugged: ok
            mounted: ok
            running: ok
            exited: critical
            stopped: critical

        tags:
        - mykey1:myvalue1
        - mykey2:myvalue2

    init_config:
    # No init_config details needed
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
        systemd: {
          instances: [
            {
              unit_names: [
                'myservice1.service',
                'myservice2.service'
              ],
              substate_status_mapping: [
                myservice1.service: {
                  running: 'ok',
                  exited: 'critical'
                },
                myservice2.service: {
                  plugged: 'ok',
                  mounted: 'ok',
                  running: 'ok',
                  exited: 'critical',
                  stopped: 'critical'
                }
              ],
              tags: [
                'mykey1:myvalue1',
                'mykey2:myvalue2'
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

  it { is_expected.to add_datadog_monitor('systemd') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/systemd.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
