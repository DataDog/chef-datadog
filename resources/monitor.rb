#
# Cookbook Name:: datadog
# Resource:: monitor
#
# Copyright 2013, Datadog
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

# Configure a service via its yaml file

property :cookbook, String, default: 'datadog'

# checks have 3 sections: init_config, instances, logs
# we mimic these here, no validation is performed until the template
# is evaluated.
property :init_config, Hash, required: false, default: {}
property :instances, Array, required: false, default: []
property :logs, Array, required: false, default: []
property :version, Integer, required: false, default: nil
property :use_integration_template, [TrueClass, FalseClass], required: false, default: false

# Creates the proper yaml file in /etc/dd-agent/conf.d/
action :add do # rubocop:disable Metrics/BlockLength
  Chef::Log.debug "Adding monitoring for #{new_resource.name}"
  template ::File.join(yaml_dir, "#{new_resource.name}.yaml") do
    if node['platform_family'] == 'windows'
      owner 'Administrators'
      rights :full_control, 'Administrators'
      inherits false
    else
      owner 'dd-agent'
      mode '600'
    end

    source 'integration.yaml.erb' if new_resource.use_integration_template

    variables(
      init_config: new_resource.init_config,
      instances:   new_resource.instances,
      version:     new_resource.version,
      logs:        new_resource.logs
    )
    cookbook new_resource.cookbook
    sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
    notifies :restart, 'service[datadog-agent]', :delayed if node['datadog']['agent_start']
  end

  service_provider = nil
  if node['datadog']['agent6'] &&
     (((node['platform'] == 'amazon' || node['platform_family'] == 'amazon') && node['platform_version'].to_i != 2) ||
     (node['platform'] != 'amazon' && node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7))
    # use Upstart provider explicitly for Agent 6 on Amazon Linux < 2.0 and RHEL < 7
    service_provider = Chef::Provider::Service::Upstart
  end
  service 'datadog-agent' do
    service_name node['datadog']['agent_name']
    provider service_provider unless service_provider.nil?
    restart_command "powershell restart-service #{node['datadog']['agent_name']} -Force" if node['platform_family'] == 'windows'
    stop_command "powershell stop-service #{node['datadog']['agent_name']} -Force" if node['platform_family'] == 'windows'
    # HACK: the restart can fail when we hit systemd's restart limits (by default, 5 starts every 10 seconds)
    # To workaround this, retry once after 5 seconds, and a second time after 10 seconds
    retries 2
    retry_delay 5
  end
end

action :remove do
  confd_dir = yaml_dir
  Chef::Log.debug "Removing #{new_resource.name} from #{confd_dir}"
  file ::File.join(confd_dir, "#{new_resource.name}.yaml") do
    action :delete
    sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
    notifies :restart, 'service[datadog-agent]', :delayed if node['datadog']['agent_start']
  end

  service_provider = nil
  if node['datadog']['agent6'] &&
     (((node['platform'] == 'amazon' || node['platform_family'] == 'amazon') && node['platform_version'].to_i != 2) ||
     (node['platform'] != 'amazon' && node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7))
    # use Upstart provider explicitly for Agent 6 on Amazon Linux < 2.0 and RHEL < 7
    service_provider = Chef::Provider::Service::Upstart
  end
  service 'datadog-agent' do
    service_name node['datadog']['agent_name']
    provider service_provider unless service_provider.nil?
    restart_command "powershell restart-service #{node['datadog']['agent_name']} -Force" if node['platform_family'] == 'windows'
    stop_command "powershell stop-service #{node['datadog']['agent_name']} -Force" if node['platform_family'] == 'windows'
  end
end

private

def yaml_dir
  if node['datadog']['agent6']
    ::File.join(node['datadog']['agent6_config_dir'], 'conf.d')
  else
    ::File.join(node['datadog']['config_dir'], 'conf.d')
  end
end
