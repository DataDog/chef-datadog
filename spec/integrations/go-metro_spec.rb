describe 'datadog::go-metro' do
  context 'with default init_config and libcap package on RHEL7' do
    expected_yaml = <<-EOF
      logs: ~
      init_config:
        snaplen: 512
        idle_ttl: 300
        exp_ttl: 60
        statsd_ip: 127.0.0.1
        statsd_port: 8125
        log_to_file: true
        log_level: info

      instances:
        - interface: eth0
          tags:
            - env:prod
          ips:
            - 10.0.0.1
            - 10.0.0.2
            - 10.0.0.3
          hosts:
            - app.datadoghq.com
        - interface: eth1
          tags:
            - env:qa
          ips:
            - 192.168.0.22
          hosts:
            - docs.datadoghq.com
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        step_into: ['datadog_monitor'], platform: 'redhat', version: '7.3'
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.normal['datadog'] = {
          api_key: 'someapikey',
          'go-metro' => {
            instances: [
              {
                interface: 'eth0',
                tags: ['env:prod'],
                ips: ['10.0.0.1', '10.0.0.2', '10.0.0.3'],
                hosts: ['app.datadoghq.com']
              },
              {
                interface: 'eth1',
                tags: ['env:qa'],
                ips: ['192.168.0.22'],
                hosts: ['docs.datadoghq.com']
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    before(:each) do
      stub_command('setcap -v cap_net_raw+ep /opt/datadog-agent/bin/go-metro')
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to install_package('libcap') }

    it {
      is_expected.to run_execute('setcap go-metro').with(
        command: 'setcap cap_net_raw+ep /opt/datadog-agent/bin/go-metro'
      )
    }

    it { is_expected.to add_datadog_monitor('go-metro') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(
        render_file('/etc/datadog-agent/conf.d/go-metro.d/conf.yaml')
        .with_content { |content|
          expect(YAML.safe_load(content).to_json).to be_json_eql(
            YAML.safe_load(expected_yaml).to_json
          )
        }
      )
    end
  end

  context 'with modified init_config, libcap package on Ubuntu 16.04' do
    expected_yaml = <<-EOF
      logs: ~
      init_config:
        snaplen: 1024
        idle_ttl: 300
        exp_ttl: 120
        statsd_ip: 127.0.0.5
        statsd_port: 8125
        log_to_file: true
        log_level: debug

      instances:
        - interface: eth0
          tags:
            - env:prod
          ips:
            - 10.0.0.1
            - 10.0.0.2
            - 10.0.0.3
          hosts:
            - app.datadoghq.com
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
          'go-metro' => {
            libcap_package: {
              package_name: 'libcap2-bin',
              version: '123'
            },
            init_config: {
              snaplen: 1024,
              idle_ttl: 300,
              exp_ttl: 120,
              statsd_ip: '127.0.0.5',
              log_level: 'debug'
            },
            instances: [
              {
                interface: 'eth0',
                tags: ['env:prod'],
                ips: ['10.0.0.1', '10.0.0.2', '10.0.0.3'],
                hosts: ['app.datadoghq.com']
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    before(:each) do
      stub_command('setcap -v cap_net_raw+ep /opt/datadog-agent/bin/go-metro')
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it {
      is_expected.to install_package('libcap').with(
        package_name: 'libcap2-bin',
        version: '123'
      )
    }

    it {
      is_expected.to run_execute('setcap go-metro').with(
        command: 'setcap cap_net_raw+ep /opt/datadog-agent/bin/go-metro'
      )
    }

    it { is_expected.to add_datadog_monitor('go-metro') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(
        render_file('/etc/datadog-agent/conf.d/go-metro.d/conf.yaml')
        .with_content { |content|
          expect(YAML.safe_load(content).to_json).to be_json_eql(
            YAML.safe_load(expected_yaml).to_json
          )
        }
      )
    end
  end

  context 'on a windows platform' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        step_into: ['datadog_monitor'], platform: 'windows', version: '2012R2'
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.normal['datadog'] = {
          api_key: 'someapikey'
        }
      end
    end

    it 'bails out with a fatal log message' do
      allow(Chef::Log).to receive(:fatal).and_call_original
      expect(Chef::Log).to receive(:fatal).with("And Chef thinks this machine is windows, not 'linux'")
      expect { chef_run.converge(described_recipe) }.to raise_error(RuntimeError)
    end
  end
end
