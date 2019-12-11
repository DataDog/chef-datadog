#
# Cookbook Name:: datadog
# Recipe:: system-probe
#
# Copyright 2011-2019, Datadog
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

# Set the correct agent startup action
sysprobe_agent_start = node['datadog']['system_probe']['enabled'] ? :start : :stop

#
# Configures system-probe agent
system_probe_config_file = '/etc/datadog-agent/system-probe.yaml'
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
  owner 'root'
  group 'dd-agent'
  mode '640'
  notifies :restart, 'service[datadog-agent-sysprobe]', :delayed unless node['datadog']['system_probe']['enabled'] == false
  # since process-agent collects network info through system-probe, enabling system-probe should also restart process-agent
  notifies :restart, 'service[datadog-agent]', :delayed unless node['datadog']['system_probe']['enabled'] == false
end

# Common configuration
service_provider = nil
if Chef::Datadog.agent_major_version(node) > 5 &&
   (((node['platform'] == 'amazon' || node['platform_family'] == 'amazon') && node['platform_version'].to_i != 2) ||
    (node['platform'] == 'ubuntu' && node['platform_version'].to_f < 15.04) || # chef <11.14 doesn't use the correct service provider
   (node['platform'] != 'amazon' && node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7))
  # use Upstart provider explicitly for Agent 6 on Amazon Linux < 2.0 and RHEL < 7
  service_provider = Chef::Provider::Service::Upstart
end

service 'datadog-agent-sysprobe' do
  action [sysprobe_agent_start]
  provider service_provider unless service_provider.nil?
  supports :restart => true, :status => true, :start => true, :stop => true
  subscribes :restart, "template[#{system_probe_config_file}]", :delayed unless node['datadog']['system_probe']['enabled'] == false
end
