#
# Cookbook Name:: datadog
# Recipe:: dd-agent-config
#
# Copyright 2011-2014, Datadog
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

# This recipe is a temporary work around as the dd-agent recipe doesn't support windows
# it ensures the agent service is running and provides the link for restarting it when monitors are changed

# Set the correct Agent startup action
agent_action = node['datadog']['agent_start'] ? :start : :stop

# Make sure the config directory exists
directory "#{node['datadog']['configDir']}" do
  owner 'root' if !platform_family?('windows')
  group 'root' if !platform_family?('windows')
  mode 0755 if !platform_family?('windows')
end
directory "#{node['datadog']['configDir']}/conf.d" do
  owner 'root' if !platform_family?('windows')
  group 'root' if !platform_family?('windows')
  mode 0755 if !platform_family?('windows')
end

#
# Configures a basic agent
# To add integration-specific configurations, add 'datadog::config_name' to
# the node's run_list and set the relevant attributes
#
raise "Add a ['datadog']['api_key'] attribute to configure this node's Datadog Agent." if node['datadog'] && node['datadog']['api_key'].nil?

template '/etc/dd-agent/datadog.conf' do
  path "#{node['datadog']['configDir']}/datadog.conf"
  owner 'root' if !platform_family?('windows')
  group 'root' if !platform_family?('windows')
  mode 0644 if !platform_family?('windows')
  variables(
    :api_key => node['datadog']['api_key'],
    :dd_url => node['datadog']['url']
  )
end

# Common configuration
service 'datadog-agent' do
  service_name "#{node['datadog']['agent_name']}"
  action [:enable, agent_action]
  supports :restart => true, :status => true, :start => true, :stop => true
  subscribes :restart, 'template[/etc/dd-agent/datadog.conf]', :delayed unless node['datadog']['agent_start'] == false
end
