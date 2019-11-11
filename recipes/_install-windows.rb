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

  # Since 6.11.0, the core and APM/trace components of the Windows Agent run under
  # a specific user instead of LOCAL_SYSTEM, check whether the user has provided
  # custom credentials and use them if that's the case.
  install_options.concat(' DDAGENTUSER_NAME=').concat(Chef::Datadog.ddagentuser_name(node)) if Chef::Datadog.ddagentuser_name(node)
  install_options.concat(' DDAGENTUSER_PASSWORD=').concat(Chef::Datadog.ddagentuser_password(node)) if Chef::Datadog.ddagentuser_password(node)
end

# Use a separate resource without a `source` so that it looks in the Registry to find the MSI to use
# for the package removal
# On Chef >= 12.6, we have to use the `package` resource instead of `windows_package` to allow not specifying a source
# (this is related to the way the windows cookbook changes the provider of `windows_package` depending on the
# version of Chef, and to improvements on the `package` resource made in Chef 12.6)
# FIXME: when we remove Chef < 12.6 support on Windows, which should allow using core resources only
use_windows_package_resource = Gem::Version.new(Chef::VERSION) < Gem::Version.new('12.6.0')
if use_windows_package_resource
  windows_package 'Datadog Agent removal' do
    package_name 'Datadog Agent'
    action :nothing
  end
else
  package 'Datadog Agent removal' do
    package_name 'Datadog Agent'
    action :nothing
  end
end

package_retries = node['datadog']['agent_package_retries']
package_retry_delay = node['datadog']['agent_package_retry_delay']

unsafe_hashsums = [
  '928b00d2f952219732cda9ae0515351b15f9b9c1ea1d546738f9dc0fda70c336',
  '78b2bb2b231bcc185eb73dd367bfb6cb8a5d45ba93a46a7890fd607dc9188194'
]
fix_message = 'The file downloaded matches a known unsafe MSI - Agent versions 6.14.0/1 have been blacklisted. please use a different release. '\
        'See http://dtdg.co/win-614-fix'

# Download the installer to a temp location
remote_file temp_file do
  source node['datadog']['windows_agent_url'] + dd_agent_installer
  checksum node['datadog']['windows_agent_checksum'] if node['datadog']['windows_agent_checksum']
  retries package_retries unless package_retries.nil?
  retry_delay package_retry_delay unless package_retry_delay.nil?

  # validate the downloaded MSI is safe
  verify do |path|
    require 'digest'

    unsafe = unsafe_hashsums.include? Digest::SHA256.file(path).hexdigest
    Chef::Log.error("\n#{fix_message}\n") if unsafe

    # verify will abort update if false
    !unsafe
  end unless node['datadog']['windows_blacklist_silent_fail']

  notifies :run, 'powershell_script[datadog_6.14.x_fix]', :immediately
end

powershell_script 'datadog_6.14.x_fix' do
  # As of v1.37, the windows cookbook doesn't upgrade the package if a newer version is downloaded
  # As a workaround uninstall the package first if a new MSI is downloaded
  code <<-EOH
((New-Object System.Net.WebClient).DownloadFile('https://s3.amazonaws.com/ddagent-windows-stable/scripts/fix_6_14.ps1', $env:temp + '\\fix_6_14.ps1')); &$env:temp\\fix_6_14.ps1
  EOH

  action :nothing
  if use_windows_package_resource
    notifies :remove, 'windows_package[Datadog Agent removal]', :immediately
  else
    notifies :remove, 'package[Datadog Agent removal]', :immediately
  end
end

# Install the package
windows_package 'Datadog Agent' do # ~FC009
  source temp_file
  installer_type installer_type
  options install_options
  action :install
  if respond_to?(:returns)
    returns [0, 3010]
  else
    success_codes [0, 3010]
  end
  not_if do
    require 'digest'

    unsafe = unsafe_hashsums.include? Digest::SHA256.file(temp_file).hexdigest
    Chef::Log.warn("\n#{fix_message}\nContinuing without installing Datadog Agent.") if unsafe

    unsafe
  end
end
