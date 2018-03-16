#
# Cookbook Name:: datadog
# Recipe:: dd-agent
#
# Copyright 2011-2015, Datadog
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

# Fail here at converge time if no api_key is set
ruby_block 'datadog-api-key-unset' do
  block do
    raise "Set ['datadog']['api_key'] as an attribute or on the node's run_state to configure this node's Datadog Agent."
  end
  only_if { Chef::Datadog.api_key(node).nil? }
end

is_windows = node['platform_family'] == 'windows'

# Install the agent
if is_windows
  include_recipe 'datadog::_install-windows'
else
  include_recipe 'datadog::_install-linux'
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
if node['datadog']['agent6']
  include_recipe 'datadog::_agent6_config'
else
  # Agent 5 and lower

  # Make sure the config directory exists for Agent 5
  directory node['datadog']['config_dir'] do
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

  agent_config_file = ::File.join(node['datadog']['config_dir'], 'datadog.conf')
  template agent_config_file do # rubocop:disable Metrics/BlockLength
    def template_vars # rubocop:disable Metrics/AbcSize
      api_keys = [Chef::Datadog.api_key(node)]
      dd_urls = [node['datadog']['url']]
      node['datadog']['extra_endpoints'].each do |_, endpoint|
        next unless endpoint['enabled']
        api_keys << endpoint['api_key']
        dd_urls << if endpoint['url']
                     endpoint['url']
                   else
                     node['datadog']['url']
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
service_provider = nil
if node['datadog']['agent6'] &&
   (((node['platform'] == 'amazon' || node['platform_family'] == 'amazon') && node['platform_version'].to_i != 2) ||
   (node['platform'] != 'amazon' && node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7))
  # use Upstart provider explicitly for Agent 6 on Amazon Linux < 2.0 and RHEL < 7
  service_provider = Chef::Provider::Service::Upstart
end

service 'datadog-agent' do
  service_name node['datadog']['agent_name']
  action [agent_enable, agent_start]
  provider service_provider unless service_provider.nil?
  if is_windows
    supports :restart => true, :start => true, :stop => true
    restart_command "powershell restart-service #{node['datadog']['agent_name']} -Force"
    stop_command "powershell stop-service #{node['datadog']['agent_name']} -Force"
  else
    supports :restart => true, :status => true, :start => true, :stop => true
  end
  subscribes :restart, "template[#{agent_config_file}]", :delayed unless node['datadog']['agent_start'] == false
  # HACK: the restart can fail when we hit systemd's restart limits (by default, 5 starts every 10 seconds)
  # To workaround this, retry once after 5 seconds, and a second time after 10 seconds
  retries 2
  retry_delay 5
end

# Install integration packages
include_recipe 'datadog::integrations' unless is_windows
