describe 'datadog::systemd' do
  expected_yaml = <<-EOF
    init_config: ~
    instances:
      - substate_status_mapping:
          myservice1.service:
            exited: critical
            running: ok
          myservice2.service:
            exited: critical
            mounted: ok
            plugged: ok
            running: ok
            stopped: critical
          mysocket.socket:
            exited: critical
            running: ok
          mytimer.timer:
            exited: critical
            running: ok
        tags:
          - 'mykey1:myvalue1'
          - 'mykey2:myvalue2'
        unit_names:
          - myservice1.service
          - myservice2.service
          - mysocket.socket
          - mytimer.timer
    logs: ~
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
                'myservice2.service',
                'mysocket.socket',
                'mytimer.timer'
              ],
              substate_status_mapping: [
                services: [
                  myservice1: {
                    running: 'ok',
                    exited: 'critical'
                  },
                  myservice2: {
                    plugged: 'ok',
                    mounted: 'ok',
                    running: 'ok',
                    exited: 'critical',
                    stopped: 'critical'
                  }
                ],
                sockets: [
                  mysocket: {
                    running: 'ok',
                    exited: 'critical'
                  }
                ],
                timers: [
                  mytimer: {
                    running: 'ok',
                    exited: 'critical'
                  }
                ]
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
