require 'spec_helper'

describe 'datadog::system-probe' do
  context 'with configuration' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04'
      ) do |node|
        node.name 'chef-nodename' # expected to be used as the hostname in `datadog.yaml`
        node.normal['datadog'] = {
          'api_key' => 'somethingnotnil',
          'agent_major_version' => 6,
          'system_probe' => {
            'debug_port' => 123,
            'bpf_debug' => true,
            'sysprobe_socket' => '/test/ing.sock'
          }
        }
      end.converge described_recipe
    end

    it 'is created' do
      expect(chef_run).to create_template('/etc/datadog-agent/system-probe.yaml')
    end

    it 'contains expected YAML configuration' do
      expected_yaml = <<-EOF
      system_probe_config:
        bpf_debug: true
        debug_port: 123
        enable_conntrack: false
        enabled: false
        sysprobe_socket: "/test/ing.sock"
      EOF

      expect(chef_run).to(render_file('/etc/datadog-agent/system-probe.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end

  context 'with extra_config params set' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04'
      ) do |node|
        node.name 'chef-nodename' # expected to be used as the hostname in `datadog.yaml`
        node.normal['datadog'] = {
          'api_key' => 'somethingnotnil',
          'agent_major_version' => 6,
          'extra_config' => {
            'system_probe' => {
              'max_tracked_connections' => 1000
            }
          }
        }
      end.converge described_recipe
    end

    it 'is created' do
      expect(chef_run).to create_template('/etc/datadog-agent/system-probe.yaml')
    end

    it 'contains expected YAML configuration' do
      expected_yaml = <<-EOF
      system_probe_config:
        bpf_debug: false
        debug_port: 0
        enable_conntrack: false
        enabled: false
        sysprobe_socket: "/opt/datadog-agent/run/sysprobe.sock"
        max_tracked_connections: 1000
      EOF

      expect(chef_run).to(render_file('/etc/datadog-agent/system-probe.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
