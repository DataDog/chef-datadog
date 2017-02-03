#
# Cookbook Name:: datadog
# Recipe:: _install-windows
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

dd_agent_version =
  if node['datadog']['agent_version'].respond_to?(:each_pair)
    node['datadog']['agent_version']['windows']
  else
    node['datadog']['agent_version']
  end

# If no version is specified, select the latest package
dd_agent_msi = dd_agent_version ? "ddagent-cli-#{dd_agent_version}.msi" : 'ddagent-cli.msi'
temp_file = ::File.join(Chef::Config[:file_cache_path], 'ddagent-cli.msi')

package_retries = node['datadog']['agent_package_retries']
package_retry_delay = node['datadog']['agent_package_retry_delay']

# Download the installer to a temp location
remote_file temp_file do
  source node['datadog']['windows_agent_url'] + dd_agent_msi
  checksum node['datadog']['windows_agent_checksum'] if node['datadog']['windows_agent_checksum']
  retries package_retries unless package_retries.nil?
  retry_delay package_retry_delay unless package_retry_delay.nil?
  # As of v1.37, the windows cookbook doesn't upgrade the package if a newer version is downloaded
  # As a workaround uninstall the package first if a new MSI is downloaded
  notifies :remove, 'windows_package[Datadog Agent]', :immediately
end

# Install the package
windows_package 'Datadog Agent' do # ~FC009
  source temp_file
  installer_type :msi
  options '/norestart ALLUSERS=1'
  action :install
  success_codes [0, 3010]
end
