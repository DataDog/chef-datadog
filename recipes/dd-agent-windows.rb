#
# Cookbook Name:: datadog
# Recipe:: dd-agent-windows
#
# Copyright 2014, Justin Schuhmann
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
::Chef::Recipe.send(:include, Datadog::Helper)

dd_agent_version = node['datadog']['agent_version']
# ddagent-cli-5.1.1.msi
# latest = "https://s3.amazonaws.com/ddagent-windows-stable/ddagent-cli.msi"
# url = "https://s3.amazonaws.com/ddagent-windows-stable/ddagent-cli-#{node['datadog']['agent_version']}.msi"
# Install Notepad++ so users can use a less crappy IDE
temp_dir = 'c:/windows/temp/ddagent-cli.msi'

remote_file temp_dir do
  source node['datadog']['agent_download_url']
  action :create_if_missing
end

windows_package 'Datadog Agent' do
  source temp_dir
  # msiexec /qn /i ddagent-cli.msi APIKEY="a75d0b3066596e7a0828e66e93c77e1e" HOSTNAME="my_hostname" TAGS="mytag1,mytag2"
  options "APIKEY=\"#{node['datadog']['api_key']}\" HOSTNAME=\"#{node['hostname']}\" TAGS=\"#{node['tags'].join(',')}\""
  action :install
end

#
# Configures a basic agent
# To add integration-specific configurations, add 'datadog::config_name' to
# the node's run_list and set the relevant attributes
#
raise "Add a ['datadog']['api_key'] attribute to configure this node's Datadog Agent." if node['datadog'] && node['datadog']['api_key'].nil?

if Datadog::Helper.older_than_windows2003r2?
  config_path = 'C:\Documents and Settings\All Users\Application Data\Datadog\datadog.conf'
else
  config_path = 'C:\ProgramData\Datadog\datadog.conf'
end

# Set the correct Agent startup action
agent_action = node['datadog']['agent_start'] ? :start : :stop

template "installs the datadog configuration file" do
  path config_path
  source "datadog.conf.erb"
  variables(
    :api_key => node['datadog']['api_key'],
    :dd_url => node['datadog']['url']
  )
end

# Common configuration
service 'DatadogAgent' do
  action [:enable, agent_action]
  supports :restart => true, :start => true, :stop => true, :disable => true, :enable => true
  subscribes :restart, 'template[#{config_path}]', :delayed unless node['datadog']['agent_start'] == false
end