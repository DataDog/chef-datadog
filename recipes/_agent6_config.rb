#
# Cookbook Name:: datadog
# Recipe:: _agent6_config
#
# Copyright 2011-2017, Datadog
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

is_windows = node['platform_family'] == 'windows'

# FIXME: with the agent6, we still need the agent5 conf file in duplicate in /etc/datadog-agent/trace-agent.conf
#        and /etc/datadog-agent/process-agent.conf for the trace and process agents.
#        Remove them when these agents can read from datadog.yaml.
trace_agent_config_file = ::File.join(node['datadog']['agent6_config_dir'], 'trace-agent.conf')
process_agent_config_file = ::File.join(node['datadog']['agent6_config_dir'], 'process-agent.conf')

template trace_agent_config_file do
  def conf_template_vars
    {
      :api_keys => [Chef::Datadog.api_key(node)],
      :dd_urls => [node['datadog']['url']]
    }
  end
  variables(
    if respond_to?(:lazy)
      lazy { conf_template_vars }
    else
      conf_template_vars
    end
  )
  if is_windows
    owner 'Administrators'
    rights :full_control, 'Administrators'
    inherits false
  else
    owner 'dd-agent'
    group 'dd-agent'
    mode '640'
  end
  source 'datadog.conf.erb'
  sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
  notifies :restart, 'service[datadog-agent]', :delayed unless node['datadog']['agent_start'] == false
end

template process_agent_config_file do
  def conf_template_vars
    {
      :api_keys => [Chef::Datadog.api_key(node)],
      :dd_urls => [node['datadog']['url']]
    }
  end
  variables(
    if respond_to?(:lazy)
      lazy { conf_template_vars }
    else
      conf_template_vars
    end
  )
  if is_windows
    owner 'Administrators'
    rights :full_control, 'Administrators'
    inherits false
  else
    owner 'dd-agent'
    group 'dd-agent'
    mode '640'
  end
  source 'datadog.conf.erb'
  sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
  notifies :restart, 'service[datadog-agent]', :delayed unless node['datadog']['agent_start'] == false
end

# With agent6, the process-agent and trace-agent are enabled as long-running checks
# TODO: on agent6, we can't really make the trace-agent _not_ run yet
datadog_monitor 'apm' do
  instances [{}]
  use_integration_template true
  if node['datadog']['enable_trace_agent'].is_a?(TrueClass)
    action :add
  else
    action :remove
  end
end
process_agent_init_config = { enabled: node['datadog']['enable_process_agent'] }
datadog_monitor 'process_agent' do
  init_config process_agent_init_config
  instances [{}]
  use_integration_template true
  if node['datadog']['enable_process_agent'].is_a?(TrueClass) || node['datadog']['enable_process_agent'].is_a?(FalseClass)
    action :add
  else
    action :remove
  end
end

agent6_config_file = ::File.join(node['datadog']['agent6_config_dir'], 'datadog.yaml')
template agent6_config_file do # rubocop:disable Metrics/BlockLength
  def template_vars # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    additional_endpoints = {}
    node['datadog']['extra_endpoints'].each do |_, endpoint|
      next unless endpoint['enabled']
      url = if endpoint['url']
              endpoint['url']
            else
              node['datadog']['url']
            end
      if additional_endpoints.key?(url)
        additional_endpoints[url] << endpoint['api_key']
      else
        additional_endpoints[url] = [endpoint['api_key']]
      end
    end
    extra_config = {}
    node['datadog']['extra_config'].each do |k, v|
      next if v.nil?
      extra_config[k] = v
    end
    {
      extra_config: extra_config,
      api_key: Chef::Datadog.api_key(node),
      additional_endpoints: additional_endpoints
    }
  end

  owner 'dd-agent'
  group 'dd-agent'
  mode '640'
  variables(
    if respond_to?(:lazy)
      lazy { template_vars }
    else
      template_vars
    end
  )
  sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
  notifies :restart, 'service[datadog-agent]', :delayed unless node['datadog']['agent_start'] == false
end
