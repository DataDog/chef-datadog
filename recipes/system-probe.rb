include_recipe 'datadog::dd-agent'

# Set the system-probe agent service enable or disable
agent_enable = node['datadog']['system_probe']['enabled'] ? :enable : :disable
# Set the correct Agent startup action
agent_start = node['datadog']['system_probe']['enabled'] ? :start : :stop

#
# Configures system-probe agent
#
if node['datadog']['agent6']
  include_recipe 'datadog::_agent6_config'

  system_probe_config_file = ::File.join(node['datadog']['agent6_config_dir'], 'system-probe.yaml')
  template system_probe_config_file do
    source 'system_probe.yaml.erb'
    variables(
      enabled: node['datadog']['system_probe']['enabled'],
      sysprobe_socket: node['datadog']['system_probe']['sysprobe_socket'],
      debug_port: node['datadog']['system_probe']['debug_port'],
      bpf_debug: node['datadog']['system_probe']['bpf_debug']
    )
    owner 'dd-agent'
    group 'root'
    mode '640'
    notifies :restart, 'service[datadog-agent-sysprobe]', :delayed unless agent_start == false
  end
else
  raise "system-probe agent does not run in agent5 environment"
end

# Common configuration
service_provider = nil
if node['datadog']['agent6'] &&
   (((node['platform'] == 'amazon' || node['platform_family'] == 'amazon') && node['platform_version'].to_i != 2) ||
    (node['platform'] == 'ubuntu' && node['platform_version'].to_f < 15.04) || # chef <11.14 doesn't use the correct service provider
   (node['platform'] != 'amazon' && node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7))
  # use Upstart provider explicitly for Agent 6 on Amazon Linux < 2.0 and RHEL < 7
  service_provider = Chef::Provider::Service::Upstart
end

service 'datadog-agent-sysprobe' do
  action [agent_enable, agent_start]
  provider service_provider unless service_provider.nil?
  supports :restart => true, :status => true, :start => true, :stop => true
  subscribes :restart, "template[#{system_probe_config_file}]", :delayed unless agent_start == false
end
