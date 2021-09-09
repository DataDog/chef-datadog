describe 'datadog::wmi_check' do
  context 'config wmi_check' do
    expected_yaml = <<-EOF
    init_config:
    instances:
    - class: Win32_OperatingSystem
      metrics:
        - [NumberOfProcesses, system.proc.count, gauge]
        - [NumberOfUsers, system.users.count, gauge]
    - class: Win32_PerfFormattedData_PerfProc_Process
      metrics:
        - [ThreadCount, my_app.threads.count, gauge]
        - [VirtualBytes, my_app.mem.virtual, gauge]
      filters:
        - Name: myapp
      constant_tags:
        - 'role:test'
    - class: Win32_PerfFormattedData_PerfProc_Process
      metrics:
        - [ThreadCount, proc.threads.count, gauge]
        - [VirtualBytes, proc.mem.virtual, gauge]
        - [PercentProcessorTime, proc.cpu_pct, gauge]
      filters:
        - Name: app1
        - Name: app2
        - Name: app3
      tag_by: Name
    - class: Win32_PerfFormattedData_PerfProc_Process
      metrics:
        - [IOReadBytesPerSec, proc.io.bytes_read, gauge]
      filters:
        - Name: 'app%'
      tag_by: Name
      tag_queries:
        - [IDProcess, Win32_Process, Handle, CommandLine]
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
          wmi_check: {
            instances: [
              {
                class: 'Win32_OperatingSystem',
                metrics: [
                  [
                    'NumberOfProcesses',
                    'system.proc.count',
                    'gauge'
                  ],
                  [
                    'NumberOfUsers',
                    'system.users.count',
                    'gauge'
                  ]
                ]
              },
              {
                class: 'Win32_PerfFormattedData_PerfProc_Process',
                metrics: [
                  [
                    'ThreadCount',
                    'my_app.threads.count',
                    'gauge'
                  ],
                  [
                    'VirtualBytes',
                    'my_app.mem.virtual',
                    'gauge'
                  ]
                ],
                filters: [
                  {
                    Name: 'myapp'
                  }
                ],
                constant_tags: [
                  'role:test'
                ]
              },
              {
                class: 'Win32_PerfFormattedData_PerfProc_Process',
                metrics: [
                  [
                    'ThreadCount',
                    'proc.threads.count',
                    'gauge'
                  ],
                  [
                    'VirtualBytes',
                    'proc.mem.virtual',
                    'gauge'
                  ],
                  [
                    'PercentProcessorTime',
                    'proc.cpu_pct',
                    'gauge'
                  ]
                ],
                filters: [
                  {
                    Name: 'app1'
                  },
                  {
                    Name: 'app2'
                  },
                  {
                    Name: 'app3'
                  }
                ],
                tag_by: 'Name'
              },
              {
                class: 'Win32_PerfFormattedData_PerfProc_Process',
                metrics: [
                  [
                    'IOReadBytesPerSec',
                    'proc.io.bytes_read',
                    'gauge'
                  ]
                ],
                filters: [
                  {
                    Name: 'app%'
                  }
                ],
                tag_by: 'Name',
                tag_queries: [
                  [
                    'IDProcess',
                    'Win32_Process',
                    'Handle',
                    'CommandLine'
                  ]
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

    it { is_expected.to add_datadog_monitor('wmi_check') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/wmi_check.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
