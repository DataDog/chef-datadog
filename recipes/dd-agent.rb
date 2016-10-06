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
# Set the correct config file
agent_config_file = ::File.join(node['datadog']['config_dir'], 'datadog.conf')

# Make sure the config directory exists
directory node['datadog']['config_dir'] do
  if is_windows
    owner 'Administrators'
    rights :full_control, 'Administrators'
    inherits false
  else
    owner 'dd-agent'
    group 'root'
    mode 0755
  end
end

#
# Configures a basic agent
# To add integration-specific configurations, add 'datadog::config_name' to
# the node's run_list and set the relevant attributes
#
raise "Add a ['datadog']['api_key'] attribute to configure this node's Datadog Agent." if node['datadog'] && node['datadog']['api_key'].nil?

api_keys = [node['datadog']['api_key']]
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

template agent_config_file do
  if is_windows
    owner 'Administrators'
    rights :full_control, 'Administrators'
    inherits false
  else
    owner 'dd-agent'
    group 'root'
    mode 0640
  end
  variables(
    :api_keys => api_keys,
    :dd_urls => dd_urls
  )
  sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
end

# Common configuration
service 'datadog-agent' do
  service_name node['datadog']['agent_name']
  action [agent_enable, agent_start]
  if is_windows
    supports :restart => true, :start => true, :stop => true
  else
    supports :restart => true, :status => true, :start => true, :stop => true
  end
  subscribes :restart, "template[#{agent_config_file}]", :delayed unless node['datadog']['agent_start'] == false
end

# Install integration packages
include_recipe 'datadog::integrations' unless is_windows
