# Copyright:: 2011-Present, Datadog
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

# Install/remove a Datadog integration
# This resource basically wraps the datadog-agent integration command to be able
# to install and remove integrations from a Chef recipe.
# The datadog_resource must be used on a system where the datadog-agent has
# already been setup.

# enable unified mode on specific Chef versions.
# See CHEF-33 Deprecation warning:
# https://docs.chef.io/deprecations_unified_mode/

unified_mode true if respond_to?(:unified_mode)

default_action :install

property :property_name, String, name_property: true
property :version, String, required: true
property :third_party, [true, false], required: false, default: false
property :local_wheel, String, required: false

action :install do
  if Chef::Datadog.agent_major_version(node) == 5
    Chef::Log.error('The datadog_integration resource is not available with Agent v5.')
    return
  end

  Chef::Log.debug("Getting integration #{new_resource.property_name}")

  install_params = if new_resource.local_wheel
                     unless ::File.exist?(new_resource.local_wheel)
                       error_message = "The local_wheel value \"#{new_resource.local_wheel}\" file not found"
                       Chef::Log.fatal(error_message)
                       raise error_message
                     end

                     # The Agent cannot perform any verification on local wheels.
                     "--local-wheel \"#{new_resource.local_wheel}\""
                   else
                     # Space at the end of '--third-party ' is intentional, so that if --third-party is not specified, no additional space is added to the command line
                     "#{'--third-party ' if new_resource.third_party}#{new_resource.property_name}==#{new_resource.version}"
                   end

  execute 'integration install' do
    command   "#{agent_exe_filepath} integration install #{install_params}"
    user      'dd-agent' unless platform_family?('windows')

    not_if {
      output = shell_out("#{agent_exe_filepath} integration show -q #{new_resource.property_name}").stdout
      output.strip == new_resource.version
    }
    notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
  end
end

action :remove do
  if Chef::Datadog.agent_major_version(node) == 5
    Chef::Log.error('The datadog_integration resource is not available with Agent v5.')
    return
  end

  Chef::Log.debug("Removing integration #{new_resource.property_name}")

  execute 'integration remove' do
    command   "#{agent_exe_filepath} integration remove #{new_resource.property_name}"
    user      'dd-agent' unless platform_family?('windows')

    not_if {
      output = shell_out("#{agent_exe_filepath} integration show -q #{new_resource.property_name}").stdout
      output.strip.empty?
    }
    notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
  end
end

def agent_exe_filepath
  if platform_family?('windows')
    # This will use the definition of the Service in the machine registry, which is wrapped in quotes for the space in path issue.
    registry_get_values('HKLM\\SYSTEM\\CurrentControlSet\\Services\\DatadogAgent').select { |v| v[:name] == 'ImagePath' }.first[:data]
  else
    '/opt/datadog-agent/bin/agent/agent'
  end
end
