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

dd_agent5_version =
  if node['datadog']['agent_version'].respond_to?(:each_pair)
    node['datadog']['agent_version']['windows']
  else
    node['datadog']['agent_version']
  end

dd_agent6_version =
  if node['datadog']['agent6_version'].respond_to?(:each_pair)
    node['datadog']['agent6_version']['windows']
  else
    node['datadog']['agent6_version']
  end

if node['datadog']['agent6']
  dd_agent_version = dd_agent6_version
  dd_agent_latest = 'datadog-agent-6-latest.amd64'
else
  dd_agent_version = dd_agent5_version
  # The latest package basename is `ddagent-cli-latest` for '~> 5.12' versions
  dd_agent_latest = 'ddagent-cli-latest'
end

# If no version is specified, select the latest package.
dd_agent_installer_basename = dd_agent_version ? "ddagent-cli-#{dd_agent_version}" : dd_agent_latest
temp_file_basename = ::File.join(Chef::Config[:file_cache_path], 'ddagent-cli')

if node['datadog']['windows_agent_use_exe']
  dd_agent_installer = "#{dd_agent_installer_basename}.exe"
  temp_file = "#{temp_file_basename}.exe"
  installer_type = :custom
  install_options = '/q'
else
  dd_agent_installer = "#{dd_agent_installer_basename}.msi"
  temp_file = "#{temp_file_basename}.msi"
  installer_type = :msi
  # Agent >= 5.12.0 installs per-machine by default, but specifying ALLUSERS=1 shouldn't affect the install
  install_options = '/norestart ALLUSERS=1'
end

package 'Datadog Agent removal' do
  package_name 'Datadog Agent'
  action :nothing
end

package_retries = node['datadog']['agent_package_retries']
package_retry_delay = node['datadog']['agent_package_retry_delay']

# Build source URL to download the installer
source_url = node['datadog']['windows_agent_url'] + dd_agent_installer
source_url = node['datadog']['windows_agent_direct_url'] if node['datadog']['windows_agent_direct_url']

# Download the installer to a temp location
remote_file temp_file do
  source      source_url
  checksum    node['datadog']['windows_agent_checksum'] if node['datadog']['windows_agent_checksum']
  retries     package_retries unless package_retries.nil?
  retry_delay package_retry_delay unless package_retry_delay.nil?
  # As of v1.37, the windows cookbook doesn't upgrade the package if a newer version is downloaded
  # As a workaround uninstall the package first if a new MSI is downloaded
  notifies    :remove, 'package[Datadog Agent removal]', :immediately
end

# Install the package
windows_package 'Datadog Agent' do # ~FC009
  source temp_file
  installer_type installer_type
  options install_options
  action :install
  returns [0, 3010]
end
