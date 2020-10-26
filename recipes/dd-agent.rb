#
# Cookbook:: datadog
# Recipe:: dd-agent
#
# Copyright:: 2011-2015, Datadog
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

require 'yaml' # Our erb templates need this

if node['datadog'].include?('agent6')
  Chef::Log.warn('The boolean "agent6" is no longer used by this cookbook since version 4.0.0. Use "agent_major_version" instead. To keep the previous behaviour pin a 3.x version of the cookbook.')
end

%w[agent6_version agent6_package_action agent6_aptrepo agent6_aptrepo_dist agent6_yumrepo agent6_yumrepo_suse].each do |deprecated|
  if node['datadog'].include?(deprecated)
    Chef::Log.warn("The field '#{deprecated}' is no longer used by this cookbook since version 4.0.0. Find an equivalent property in the README. To keep the previous behaviour pin a 3.x version of the cookbook.")
  end
end

# Fail here at converge time if no api_key is set
ruby_block 'datadog-api-key-unset' do
  block do
    raise "Set ['datadog']['api_key'] as an attribute or on the node's run_state to configure this node's Datadog Agent."
  end
  only_if { Chef::Datadog.api_key(node).nil? }
end

agent_major_version = Chef::Datadog.agent_major_version(node)
agent_minor_version = Chef::Datadog.agent_minor_version(node)
is_windows = platform_family?('windows')

# Install the agent
if is_windows
  include_recipe 'datadog::_install-windows'
else
  include_recipe 'datadog::_install-linux'
end

if !node['datadog']['agent_enable'] && node['datadog']['enable_process_agent']
  Chef::Log.warn("'agent_enable' is set to 'false', but 'enable_process_agent' is set to 'true'. This will cause the datadog-agent to start, since the process-agent depends on it.")
end

if !node['datadog']['agent_enable'] && node['datadog']['enable_trace_agent']
  Chef::Log.warn("'agent_enable' is set to 'false', but 'enable_trace_agent' is set to 'true'. This will cause the datadog-agent to start, since the trace-agent depends on it.")
end

# Set the Agent service enable or disable
agent_enable = node['datadog']['agent_enable'] ? :enable : :disable
# Set the correct Agent startup action
agent_start = node['datadog']['agent_start'] ? :start : :stop

#
# Configures a basic agent
# To add integration-specific configurations, add 'datadog::config_name' to
# the node's run_list and set the relevant attributes
#
if agent_major_version > 5
  include_recipe 'datadog::_agent6_config'
  agent_config_dir = is_windows ? "#{ENV['ProgramData']}/Datadog" : '/etc/datadog-agent'
  directory agent_config_dir do
    if is_windows
      inherits true # Agent 6/7 rely on inheritance being enabled. Reset it in case it was disabled when installing Agent 5.
    end
  end
else
  # Make sure the config directory exists for Agent 5
  agent_config_dir = is_windows ? "#{ENV['ProgramData']}/Datadog" : '/etc/dd-agent'
  directory agent_config_dir do
    if is_windows
      owner 'Administrators'
      rights :full_control, 'Administrators'
      inherits false
    else
      owner 'dd-agent'
      group 'root'
      mode '755'
    end
  end
  agent_config_file = ::File.join(agent_config_dir, 'datadog.conf')
  template agent_config_file do
    def template_vars
      # Default value of node['datadog']['url'] is now nil for an Agent 6
      # but for compatibility with Agent 5, we still need to have the value
      # set. It's set here.
      dd_url = 'https://app.datadoghq.com'
      dd_url = node['datadog']['url'] unless node['datadog']['url'].nil?

      api_keys = [Chef::Datadog.api_key(node)]
      dd_urls = [dd_url]
      node['datadog']['extra_endpoints'].each do |_, endpoint|
        next unless endpoint['enabled']
        api_keys << endpoint['api_key']
        dd_urls << if endpoint['url']
                     endpoint['url']
                   else
                     dd_url
                   end
      end
      {
        :api_keys => api_keys,
        :dd_urls => dd_urls
      }
    end
    if is_windows
      owner 'Administrators'
      rights :full_control, 'Administrators'
      inherits false
    else
      owner 'dd-agent'
      group 'root'
      mode '640'
    end
    variables(
      if respond_to?(:lazy)
        lazy { template_vars }
      else
        template_vars
      end
    )
    sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
  end
end

# Common configuration
service_provider = Chef::Datadog.service_provider(node)

service_name = is_windows ? 'DatadogAgent' : 'datadog-agent'

service 'datadog-agent' do
  service_name service_name
  action [agent_enable, agent_start]
  provider service_provider unless service_provider.nil?
  if is_windows
    supports :restart => true, :start => true, :stop => true
    restart_command "powershell restart-service #{service_name} -Force"
    stop_command "powershell stop-service #{service_name} -Force"
  else
    supports :restart => true, :status => true, :start => true, :stop => true
  end
  subscribes :restart, "template[#{agent_config_file}]", :delayed if node['datadog']['agent_start']
  # HACK: the restart can fail when we hit systemd's restart limits (by default, 5 starts every 10 seconds)
  # To workaround this, retry once after 5 seconds, and a second time after 10 seconds
  retries 2
  retry_delay 5
end

system_probe_managed = node['datadog']['system_probe']['manage_config']
agent_version_greater_than_6_11 = agent_major_version > 5 && (agent_minor_version.nil? || agent_minor_version > 11) || agent_major_version > 6

# System probe requires at least agent 6.12, before that it was called the network-tracer
system_probe_supported = agent_version_greater_than_6_11 && !is_windows

# system-probe is a dependency of the agent on Linux
include_recipe 'datadog::system-probe' if system_probe_managed && system_probe_supported

# Installation metadata to let know the agent about installation method and its version
include_recipe 'datadog::install_info'

# Install integration packages
include_recipe 'datadog::integrations' unless is_windows
