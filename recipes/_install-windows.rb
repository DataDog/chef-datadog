#
# Cookbook:: datadog
# Recipe:: _install-windows
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

include_recipe 'chef_handler'

dd_agent_flavor = Chef::Datadog.agent_flavor(node)

if dd_agent_flavor != 'datadog-agent'
  raise "Unsupported agent flavor '#{dd_agent_flavor}' on Windows (only supports 'datadog-agent')"
end

module Windows
  class Helper
    def clean_user(context)
      resource = context.resource_collection.lookup('windows_env[DDAGENTUSER_NAME]')
      resource.run_action(:delete)
    end

    def clean_password(context)
      resource = context.resource_collection.lookup('windows_env[DDAGENTUSER_PASSWORD]')
      resource.run_action(:delete)
    end

    def unmute_host(context)
      resource = context.resource_collection.lookup('ruby_block[Unmute host after installing]')
      resource.run_action(:run)
    end
  end
end

ddagentuser_name = Chef::Datadog.ddagentuser_name(node)
ddagentuser_password = Chef::Datadog.ddagentuser_password(node)

if ddagentuser_name
  Chef.event_handler do
    on :run_failed do
      Windows::Helper.new.clean_user(Chef.run_context)
    end
  end
  windows_env 'DDAGENTUSER_NAME' do
    value ddagentuser_name
    sensitive true
  end
end

if ddagentuser_password
  Chef.event_handler do
    on :run_failed do
      Windows::Helper.new.clean_password(Chef.run_context)
    end
  end
  windows_env 'DDAGENTUSER_PASSWORD' do
    value ddagentuser_password
    sensitive true
  end
end

dd_agent_version = Chef::Datadog.agent_version(node)

if dd_agent_version.nil?
  # Use latest
  agent_major_version = Chef::Datadog.agent_major_version(node)
  dd_agent_installer_basename = (agent_major_version == 5) ? 'ddagent-cli-latest' : "datadog-agent-#{agent_major_version}-latest.amd64"
else
  dd_agent_installer_prefix = (node['datadog']['windows_agent_installer_prefix'] || 'ddagent-cli')
  dd_agent_installer_basename = "#{dd_agent_installer_prefix}-#{dd_agent_version}"
end

dd_agent_install_npm = Chef::Datadog.npm_install(node)

temp_file_basename = ::File.join(Chef::Config[:file_cache_path], 'ddagent-cli')
temp_fix_file = ::File.join(Chef::Config[:file_cache_path], 'fix_6_14.ps1')

if node['datadog']['windows_agent_use_exe']
  dd_agent_installer = "#{dd_agent_installer_basename}.exe"
  temp_file = "#{temp_file_basename}.exe"
  resolved_installer_type = :custom
  install_options = '/q'
else
  dd_agent_installer = "#{dd_agent_installer_basename}.msi"
  temp_file = "#{temp_file_basename}.msi"
  resolved_installer_type = :msi
  # Agent >= 5.12.0 installs per-machine by default, but specifying ALLUSERS=1 shouldn't affect the install
  install_options = '/norestart ALLUSERS=1'

  # Since 6.11.0, the core and APM/trace components of the Windows Agent run under
  # a specific user instead of LOCAL_SYSTEM, check whether the user has provided
  # custom credentials and use them if that's the case.
  install_options.concat(' DDAGENTUSER_NAME=%DDAGENTUSER_NAME%') if ddagentuser_name
  install_options.concat(' DDAGENTUSER_PASSWORD=%DDAGENTUSER_PASSWORD%') if ddagentuser_password

  install_options.concat(' ADDLOCAL=MainApplication,NPM') if dd_agent_install_npm
end

package 'Datadog Agent removal' do
  package_name 'Datadog Agent'
  timeout node['datadog']['windows_msi_timeout']
  action :nothing
end

package_retries = node['datadog']['agent_package_retries']
package_retry_delay = node['datadog']['agent_package_retry_delay']

unsafe_hashsums = [
  '928b00d2f952219732cda9ae0515351b15f9b9c1ea1d546738f9dc0fda70c336',
  '78b2bb2b231bcc185eb73dd367bfb6cb8a5d45ba93a46a7890fd607dc9188194'
]
fix_message = 'The file downloaded matches a known unsafe MSI - Agent versions 6.14.0/1 have been blacklisted. please use a different release. '\
        'See http://dtdg.co/win-614-fix'

must_reinstall = Chef::Datadog::WindowsInstallHelpers.must_reinstall?(node)

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

  # these are notified in order
  if must_reinstall
    notifies :create, "remote_file[#{temp_fix_file}]", :immediately
    notifies :run, 'powershell_script[datadog_6.14.x_fix]', :immediately
  end
end

remote_file temp_fix_file do
  source "#{node['datadog']['windows_agent_url']}scripts/fix_6_14.ps1"
  retries package_retries unless package_retries.nil?
  retry_delay package_retry_delay unless package_retry_delay.nil?
  action :nothing
end

powershell_script 'datadog_6.14.x_fix' do
  # As of v1.37, the windows cookbook doesn't upgrade the package if a newer version is downloaded
  # As a workaround uninstall the package first if a new MSI is downloaded
  code "&#{temp_fix_file}"
  action :nothing
  notifies :remove, 'package[Datadog Agent removal]', :immediately
end

if node['datadog']['windows_mute_hosts_during_install']
  unless Chef::Datadog.application_key(node)
    Chef::Log.error('windows_mute_hosts_during_install requires an application_key but it is not set.')
  end
  ruby_block 'Mute host while installing' do
    block do
      require 'net/http'
      require 'uri'
      require 'json'
      hostname = node['datadog']['hostname']
      uri = URI.parse("https://api.datadoghq.com/api/v1/host/#{hostname}/mute")
      request = Net::HTTP::Post.new(uri)
      request.content_type = 'application/json'
      request['Dd-Api-Key'] = Chef::Datadog.api_key(node)
      request['Dd-Application-Key'] = Chef::Datadog.application_key(node)
      request.body = JSON.dump({
        'message': 'Muted during install by datadog-chef cookbook',
        'end': Time.now.getutc.to_i + (60 * 60), # Set to automatically unmute in 60 minutes
      })
      response = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: true }) do |http|
        http.request(request)
      end
      if response.code != '200'
        Chef::Log.warn("Mute request failed with code #{response.code}: #{response.body}")
      end
    end
    action :nothing
  end
  ruby_block 'Unmute host after installing' do
    block do
      require 'net/http'
      require 'uri'
      require 'json'
      hostname = node['datadog']['hostname']
      uri = URI.parse("https://api.datadoghq.com/api/v1/host/#{hostname}/unmute")
      request = Net::HTTP::Post.new(uri)
      request['Dd-Api-Key'] = Chef::Datadog.api_key(node)
      request['Dd-Application-Key'] = Chef::Datadog.application_key(node)
      response = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: true }) do |http|
        http.request(request)
      end
      if response.code != '200'
        Chef::Log.warn("Unmute request failed with code #{response.code}: #{response.body}")
      end
    end
    action :nothing
  end
  Chef.event_handler do
    on :run_failed do
      Windows::Helper.new.unmute_host(Chef.run_context)
    end
  end
end

# Install the package
windows_package 'Datadog Agent' do # ~FC009
  source temp_file
  installer_type resolved_installer_type
  options install_options
  timeout node['datadog']['windows_msi_timeout']
  action :install
  # Before 3.0.0, we adviced users to use the windows cookbook ~> 1.38.0,
  # we should probably keep the compatibilty for some time.
  if respond_to?(:returns)
    returns [0, 3010]
  else
    success_codes [0, 3010]
  end
  if node['datadog']['windows_mute_hosts_during_install']
    notifies :run, 'ruby_block[Mute host while installing]', :before
    notifies :run, 'ruby_block[Unmute host after installing]', :immediately
  end
  not_if do
    require 'digest'

    unsafe = File.file?(temp_file) && unsafe_hashsums.include?(Digest::SHA256.file(temp_file).hexdigest)
    Chef::Log.warn("\n#{fix_message}\nContinuing without installing Datadog Agent.") if unsafe

    unsafe
  end
end

if ddagentuser_name
  windows_env 'DDAGENTUSER_NAME' do
    action :delete
    sensitive true
  end
end

if ddagentuser_password
  windows_env 'DDAGENTUSER_PASSWORD' do
    action :delete
    sensitive true
  end
end
