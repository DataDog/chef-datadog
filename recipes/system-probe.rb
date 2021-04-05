#
# Cookbook:: datadog
# Recipe:: system-probe
#
# Copyright:: 2011-2019, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

is_windows = platform_family?('windows')

# Set the correct agent startup action
sysprobe_enabled = node['datadog']['system_probe']['enabled'] || node['datadog']['system_probe']['network_enabled']
sysprobe_agent_start = sysprobe_enabled ? :start : :stop

#
# Configures system-probe agent
system_probe_config_file =
  if is_windows
    'C:/ProgramData/Datadog/system-probe.yaml'
  else
    '/etc/datadog-agent/system-probe.yaml'
  end

system_probe_config_file_exists = ::File.exist?(system_probe_config_file)

template system_probe_config_file do
  extra_config = {}
  if node['datadog']['extra_config'] && node['datadog']['extra_config']['system_probe']
    node['datadog']['extra_config']['system_probe'].each do |k, v|
      next if v.nil?
      extra_config[k] = v
    end
  end

  source 'system_probe.yaml.erb'
  variables(
    enabled: node['datadog']['system_probe']['enabled'],
    sysprobe_socket: node['datadog']['system_probe']['sysprobe_socket'],
    debug_port: node['datadog']['system_probe']['debug_port'],
    bpf_debug: node['datadog']['system_probe']['bpf_debug'],
    enable_conntrack: node['datadog']['system_probe']['enable_conntrack'],
    extra_config: extra_config
  )

  if is_windows
    owner 'Administrators'
    rights :full_control, 'Administrators'
    inherits false
  else
    owner 'root'
    group 'dd-agent'
    mode '640'
  end

  notifies :restart, 'service[datadog-agent-sysprobe]', :delayed if sysprobe_enabled
  # since process-agent collects network info through system-probe, enabling system-probe should also restart process-agent
  notifies :restart, 'service[datadog-agent]', :delayed if sysprobe_enabled

  # System probe is not enabled and the file doesn't exists, don't create it
  not_if { !sysprobe_enabled && !system_probe_config_file_exists }
end

# Common configuration
service_provider = Chef::Datadog.service_provider(node)

service_name = is_windows ? 'datadog-system-probe' : 'datadog-agent-sysprobe'

service 'datadog-agent-sysprobe' do
  service_name service_name
  action [sysprobe_agent_start]
  provider service_provider unless service_provider.nil?
  if is_windows
    supports :restart => true, :start => true, :stop => true
    restart_command "powershell restart-service #{service_name} -Force"
    stop_command "powershell stop-service #{service_name} -Force"
  else
    supports :restart => true, :status => true, :start => true, :stop => true
  end
  supports :restart => true, :status => true, :start => true, :stop => true
  subscribes :restart, "template[#{system_probe_config_file}]", :delayed if sysprobe_enabled
end
