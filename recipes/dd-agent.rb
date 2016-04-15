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

# Install the agent
if node['platform_family'] == 'windows'
  include_recipe 'datadog::_install-windows'
else
  include_recipe 'datadog::_install-linux'
end

# Set the correct Agent startup action
agent_action = node['datadog']['agent_start'] ? :start : :stop
# Set the correct config file
agent_config_file = ::File.join(node['datadog']['config_dir'], 'datadog.conf')

# Make sure the config directory exists
directory node['datadog']['config_dir'] do
  if node['platform_family'] == 'windows'
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

# Common configuration
if node['platform_family'] == 'windows'
  execute "datadog-agent-startup" do
    command "sc start DatadogAgent"
    action :run
    not_if 'tasklist | findstr ddagent.exe'
    only_if {::File.exists?("C:\\ProgramData\\Datadog\\datadog.conf")}
  end

  execute "datadog-agent-restart" do
    command "taskkill /F /IM ddagent.exe && sc start DatadogAgent"
    action :nothing
    #only_if 'tasklist | findstr ddagent.exe'
    ignore_failure true
  end
end

service 'datadog-agent' do
  service_name node['datadog']['agent_name']
  action [:enable, agent_action]
  if node['platform_family'] == 'windows'
    supports :restart => true, :start => true, :stop => true
  else
    supports :restart => true, :status => true, :start => true, :stop => true
  end
  action [ :nothing ]
end

template agent_config_file do
  if node['platform_family'] == 'windows'
    owner 'Administrators'
    rights :full_control, 'Administrators'
    inherits false
  else
    owner 'dd-agent'
    group 'root'
    mode 0640
  end
  variables(
    :api_key => node['datadog']['api_key'],
    :dd_url => node['datadog']['url']
  )
  if node['platform_family'] == 'windows' 
    puts "TEMPLATE-WINDOWS"
    notifies :run, 'execute[datadog-agent-restart]', :delayed
  else 
    notifies :restart, 'service[datadog-agent]'
  end
end
