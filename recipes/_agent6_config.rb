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

  if is_windows
    owner 'Administrators'
    rights :full_control, 'Administrators'
    inherits false
  else
    owner 'dd-agent'
    group 'dd-agent'
    mode '640'
  end
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
