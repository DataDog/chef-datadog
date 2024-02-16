#
# Cookbook:: datadog
# Recipe:: security-agent
#
# Copyright:: 2011-Present, Datadog
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
security_agent_start = node['datadog']['agent_start'] && node['datadog']['agent_enable'] ? :start : :stop

#
# Configures security-agent agent
security_agent_config_file =
  if is_windows
    'C:/ProgramData/Datadog/security-agent.yaml'
  else
    '/etc/datadog-agent/security-agent.yaml'
  end
security_agent_config_file_exists = ::File.exist?(security_agent_config_file)

template security_agent_config_file do
  runtime_security_extra_config = {}
  if node['datadog']['extra_config'] && node['datadog']['extra_config']['security_agent'] && node['datadog']['extra_config']['security_agent']['runtime_security_config']
    node['datadog']['extra_config']['security_agent']['runtime_security_config'].each do |k, v|
      next if v.nil?
      runtime_security_extra_config[k] = v
    end
  end

  compliance_extra_config = {}
  if node['datadog']['extra_config'] && node['datadog']['extra_config']['security_agent'] && node['datadog']['extra_config']['security_agent']['compliance_config']
    node['datadog']['extra_config']['security_agent']['compliance_config'].each do |k, v|
      next if v.nil?
      compliance_extra_config[k] = v
    end
  end

  source 'security-agent.yaml.erb'
  variables(
    runtime_security_enabled: node['datadog']['security_agent']['cws']['enabled'],
    runtime_security_extra_config: runtime_security_extra_config,
    compliance_enabled: node['datadog']['security_agent']['cspm']['enabled'],
    compliance_extra_config: compliance_extra_config
  )

  unless is_windows
    owner 'root'
    group 'dd-agent'
    mode '640'
  end

  notifies :restart, 'service[datadog-agent-security]', :delayed
end

# Common configuration
service_provider = Chef::Datadog.service_provider(node)

service_name = is_windows ? 'datadog-security-agent' : 'datadog-agent-security'

service 'datadog-agent-security' do
  service_name service_name
  action [security_agent_start]
  provider service_provider unless service_provider.nil?
  if is_windows
    supports :restart => true, :start => true, :stop => true
    restart_command "powershell restart-service #{service_name} -Force"
    stop_command "powershell stop-service #{service_name} -Force"
  else
    supports :restart => true, :status => true, :start => true, :stop => true
  end
  subscribes :restart, "template[#{security_agent_config_file}]", :delayed
end