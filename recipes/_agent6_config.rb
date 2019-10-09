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

agent_config_dir = is_windows ? "#{ENV['ProgramData']}/Datadog" : '/etc/datadog-agent'
agent_config_file = ::File.join(agent_config_dir, 'datadog.yaml')
template agent_config_file do
  def template_vars
    # we need to always provide an URL value for additional endpoints.
    # use either the site option or the url one, the latter having priority.
    dd_url = 'https://app.datadoghq.com'
    dd_url = 'https://app.' + node['datadog']['site'] unless node['datadog']['site'].nil?
    dd_url = node['datadog']['url'] unless node['datadog']['url'].nil?

    additional_endpoints = {}
    node['datadog']['extra_endpoints'].each do |_, endpoint|
      next unless endpoint['enabled']
      url = (endpoint['url'] || dd_url)
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

  unless is_windows
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
