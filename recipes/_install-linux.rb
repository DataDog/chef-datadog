#
# Cookbook:: datadog
# Recipe:: _install-linux
#
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
#

# Install the Apt/Yum repository if enabled
include_recipe '::repository' if node['datadog']['installrepo']

dd_agent_version = Chef::Datadog.agent_version(node)
dd_agent_flavor = Chef::Datadog.agent_flavor(node)

package_action = node['datadog']['agent_package_action']

package_retries = node['datadog']['agent_package_retries']
package_retry_delay = node['datadog']['agent_package_retry_delay']

# Install the regular package
case node['platform_family']
when 'debian'
  apt_package dd_agent_flavor do
    version dd_agent_version
    retries package_retries unless package_retries.nil?
    retry_delay package_retry_delay unless package_retry_delay.nil?
    action package_action # default is :install
    options '--force-yes' if node['datadog']['agent_allow_downgrade']
  end

  apt_package 'datadog-signing-keys' do
    retries package_retries unless package_retries.nil?
    retry_delay package_retry_delay unless package_retry_delay.nil?
    action :upgrade
  end
when 'rhel', 'fedora', 'amazon'
  # Centos < 7 was deprecated on agent {6,7}.52
  agent_major_version = Chef::Datadog.agent_major_version(node)
  if agent_major_version.to_i >= 6 && platform_family?('rhel') && node['platform_version'].to_i < 7
    agent_minor_version = Chef::Datadog.agent_minor_version(node)
    if dd_agent_version && agent_minor_version && agent_minor_version >= 52
      # Error out with a useful message when the version was pinned to an unsupported one
      Chef::Log.error("Agent versions #{agent_major_version}.52 and above not supported by current OS (RHEL < 7 equivalent).")
      raise
    else
      # Set an upper bound for the package when the version was left unpinned
      # Bounds like this one need to go on the package name, they're not supported on the version field
      dd_agent_flavor = "#{dd_agent_flavor} < 1:#{agent_major_version}.52.0-1"
    end
  end

  if (platform_family?('rhel')   && node['platform_version'].to_i >= 8)    ||
     (platform_family?('fedora') && node['platform_version'].to_i >= 28)   ||
     (platform_family?('amazon') && node['platform_version'].to_i >= 2022)
    # yum_package doesn't work on RHEL >= 8, Fedora >= 28 and AmazonLinux >=2022
    # dnf_package only works on RHEL 8 / Fedora >= 28 if Chef 15+ is used
    dnf_package dd_agent_flavor do
      version dd_agent_version
      retries package_retries unless package_retries.nil?
      retry_delay package_retry_delay unless package_retry_delay.nil?
      action package_action # default is :install
    end
  else
    yum_package dd_agent_flavor do
      version dd_agent_version
      retries package_retries unless package_retries.nil?
      retry_delay package_retry_delay unless package_retry_delay.nil?
      action package_action # default is :install
      allow_downgrade node['datadog']['agent_allow_downgrade']
    end
  end
when 'suse'
  zypper_package dd_agent_flavor do # ~FC009
    version dd_agent_version
    retries package_retries unless package_retries.nil?
    retry_delay package_retry_delay unless package_retry_delay.nil?
    action package_action # default is :install
    # allow_downgrade is only suported for zypper_package since Chef Client 13.6
    allow_downgrade node['datadog']['agent_allow_downgrade'] if respond_to?(:allow_downgrade)
  end
end
