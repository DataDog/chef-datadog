#
# Cookbook Name:: datadog
# Recipe:: dd-agent-install-linux
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

dd_agent_version = node['datadog']['agent_version']

# If version specified and lower than 5.x
if !dd_agent_version.nil? && dd_agent_version.split('.')[0].to_i < 5
  # Select correct package name based on attribute
  dd_pkg_name = node['datadog']['install_base'] ? 'datadog-agent-base' : 'datadog-agent'

  package dd_pkg_name do
    version dd_agent_version
  end
else
  # default behavior, remove the `base` package as it is no longer needed
  package 'datadog-agent-base' do
    action :remove
  end
  # Install the regular package
  package 'datadog-agent' do
    version dd_agent_version
    action node['datadog']['agent_package_action'] # default is :install
  end
end
