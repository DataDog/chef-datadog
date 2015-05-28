#
# Cookbook Name:: datadog
# Recipe:: dd-agent-install-windows
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

dd_agent_version = node['datadog']['agent_version']

# If no version is specified, select the latest package
dd_agent_msi = dd_agent_version ? "ddagent-cli-#{dd_agent_version}.msi" : 'ddagent-cli.msi'
temp_file = "#{Chef::Config[:file_cache_path]}/#{dd_agent_msi}"

# Download the installer to a temp location
remote_file temp_file do
  source node['datadog']['windows_agent_url'] + dd_agent_msi
  action :create_if_missing
end

# Install the package
windows_package 'Datadog Agent' do
  source temp_file
  options "APIKEY=\"#{node['datadog']['api_key']}\" HOSTNAME=\"#{node['hostname']}\" TAGS=\"#{node['tags'].join(',')}\""
  action :install
end
