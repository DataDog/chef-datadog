#
# Cookbook Name:: datadog
# Recipe:: dd-agent
#
# Copyright 2011-2014, Datadog
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
if node['datadog']['installrepo']
  include_recipe "datadog::repository"
end

if node['platform_family'] == 'debian'
  # Thanks to @joepcds for the Ubuntu 11.04 fix
  # setuptools has been packaged with a bug
  # https://bugs.launchpad.net/ubuntu/+source/supervisor/+bug/777862
  if node['platform_version'].to_f == 11.04
    package 'python-setuptools'
    easy_install_package "elementtree"
  end

  # apt-1.8.0 has a bug that makes the new apt-repo not available right away
  # running apt-get update clears the issue
  log "Running apt-get update to work around COOK-2171" do
    notifies :run, "execute[apt-get update]", :immediately
    not_if "apt-cache search datadog-agent | grep datadog-agent"
  end
end

if node['datadog']['install_base']
  # This is host without Python 2.6 or 2.7

  if node['datadog']['agent_version'].nil? || node['datadog']['agent_version'].split('.')[0].to_i >= 5
    # We are trying to install agent > 5.0, so we remove datadog-agent-base and install datadog-agent

    package "datadog-agent-base" do
      action :remove
    end

    package "datadog-agent" do
      version node['datadog']['agent_version']
    end

  else
    # The version we are trying to install is < 5.0, we make sure datadog-agent is not installed 
    # and we install  datadog-agent-base
    package "datadog-agent" do
      action :remove
    end

    package "datadog-agent-base" do
      version node['datadog']['agent_version']
    end
  end

else
  # This host has python 2.6 or higher we can install datadog-agent in any cases
  package "datadog-agent" do
    version node['datadog']['agent_version']
  end
end

# Set the correct Agent startup action
agent_action = node['datadog']['agent_start'] ? :start : :stop

# Make sure the config directory exists
directory "/etc/dd-agent" do
  owner "root"
  group "root"
  mode 0755
end

#
# Configures a basic agent
# To add integration-specific configurations, add 'datadog::config_name' to
# the node's run_list and set the relevant attributes
#
raise "Add a ['datadog']['api_key'] attribute to configure this node's Datadog Agent." if node['datadog'] && node['datadog']['api_key'].nil?

template "/etc/dd-agent/datadog.conf" do
  owner "root"
  group "root"
  mode 0644
  variables(
    :api_key => node['datadog']['api_key'],
    :dd_url => node['datadog']['url']
  )
end

# Common configuration
service "datadog-agent" do
  action [:enable, agent_action]
  supports :restart => true, :status => true, :start => true, :stop => true
  subscribes :restart, 'template[/etc/dd-agent/datadog.conf]', :delayed unless node['datadog']['agent_start'] == false
end
