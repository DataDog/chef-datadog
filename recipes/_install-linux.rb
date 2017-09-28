#
# Cookbook Name:: datadog
# Recipe:: _install-linux
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

# Install the Apt/Yum repository if enabled
include_recipe 'datadog::repository' if node['datadog']['installrepo']

dd_agent5_version =
  if node['datadog']['agent_version'].respond_to?(:each_pair)
    case node['platform_family']
    when 'rhel', 'fedora', 'amazon'
      node['datadog']['agent_version']['rhel']
    else
      node['datadog']['agent_version'][node['platform_family']]
    end
  else
    node['datadog']['agent_version']
  end

dd_agent6_version =
  if node['datadog']['agent6_version'].respond_to?(:each_pair)
    case node['platform_family']
    when 'rhel', 'fedora'
      node['datadog']['agent6_version']['rhel']
    else
      node['datadog']['agent6_version'][node['platform_family']]
    end
  else
    node['datadog']['agent6_version']
  end

if node['datadog']['agent6']
  dd_agent_version = dd_agent6_version
  package_action = node['datadog']['agent6_package_action']
else
  dd_agent_version = dd_agent5_version
  package_action = node['datadog']['agent_package_action']
end

if !dd_agent_version.nil? && dd_agent_version.split('.')[0].split(':').last.to_i < 5
  # If version specified and lower than 5.x
  Chef::Log.warn 'Support for Agent pre 5.x will be removed in datadog cookbook version 3.0'
  # Select correct package name based on attribute
  dd_pkg_name = node['datadog']['install_base'] ? 'datadog-agent-base' : 'datadog-agent'

  package dd_pkg_name do
    version dd_agent_version
  end
else
  # default behavior, remove the `base` package as it is no longer needed
  package 'datadog-agent-base' do
    action :remove
    only_if 'rpm -q datadog-agent-base' if %w[rhel fedora].include?(node['platform_family'])
    not_if 'apt-cache policy datadog-agent-base | grep "Installed: (none)"' if node['platform_family'] == 'debian'
  end

  package_retries = node['datadog']['agent_package_retries']
  package_retry_delay = node['datadog']['agent_package_retry_delay']
  # Install the regular package
  case node['platform_family']
  when 'debian'
    apt_package 'datadog-agent' do
      version dd_agent_version
      retries package_retries unless package_retries.nil?
      retry_delay package_retry_delay unless package_retry_delay.nil?
      action package_action # default is :install
      options '--force-yes' if node['datadog']['agent_allow_downgrade']
    end
  when 'rhel', 'fedora', 'amazon'
    yum_package 'datadog-agent' do
      version dd_agent_version
      retries package_retries unless package_retries.nil?
      retry_delay package_retry_delay unless package_retry_delay.nil?
      action package_action # default is :install
      allow_downgrade node['datadog']['agent_allow_downgrade']
    end
  end
end
