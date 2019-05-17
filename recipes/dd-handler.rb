#
# Cookbook Name:: datadog
# Recipe:: dd-handler
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
require 'uri'

if Chef::Config[:why_run]
  # chef_handler 1.4 doesn't support why-run mode
  # see https://github.com/chef-cookbooks/chef_handler/issues/41
  Chef::Log.warn('Running in why-run mode, skipping dd-handler')
  return
end

if node['datadog']['chef_handler_version'] &&
   Gem::Version.new(node['datadog']['chef_handler_version']) < Gem::Version.new('0.10.0')
  Chef::Log.error('We do not support chef_handler_version < v0.10.0 anymore, please use a more recent version.')
  return
end

chef_gem 'chef-handler-datadog' do # ~FC009
  action :install
  version node['datadog']['chef_handler_version']
  # Chef 12 introduced `compile_time` - remove respond_to? when Chef 11 is EOL.
  compile_time true if respond_to?(:compile_time)
  clear_sources true if node['datadog']['gem_server']
  source node['datadog']['gem_server'] if node['datadog']['gem_server']
end

# add web proxy from config support
web_proxy = node['datadog']['web_proxy']
unless web_proxy['host'].nil?
  proxy_url = URI::HTTP.build(host: web_proxy['host'], port: web_proxy['port'])
  proxy_url.user = web_proxy['user']
  proxy_url.password = web_proxy['password']
  ENV['DATADOG_PROXY'] = proxy_url.to_s
end

# Create the handler to run at the end of the Chef execution
chef_handler 'Chef::Handler::Datadog' do
  def extra_endpoints
    extra_endpoints = []
    node['datadog']['extra_endpoints'].each do |_, endpoint|
      next unless endpoint['enabled']
      endpoint = Mash.new(endpoint)
      endpoint.delete('enabled')
      extra_endpoints << endpoint
    end
    extra_endpoints
  end

  def handler_config
    extra_config = node['datadog']['handler_extra_config'].reject { |_, v| v.nil? }

    # Since Agent 6 supports node['datadog']['url'] = nil, we need to fallback
    # on a default value here.
    dd_url = 'https://app.datadoghq.com'
    dd_url = node['datadog']['url'] unless node['datadog']['url'].nil?

    config = extra_config.merge(
      :api_key => Chef::Datadog.api_key(node),
      :application_key => Chef::Datadog.application_key(node),
      :use_ec2_instance_id => node['datadog']['use_ec2_instance_id'],
      :tag_prefix => node['datadog']['tag_prefix'],
      :url => dd_url,
      :extra_endpoints => extra_endpoints,
      :tags_blacklist_regex => node['datadog']['tags_blacklist_regex'],
      :send_policy_tags => node['datadog']['send_policy_tags'],
      :tags_submission_retries => node['datadog']['tags_submission_retries']
    )

    unless node['datadog']['use_ec2_instance_id']
      config[:hostname] = node['datadog']['hostname']
    end
    config
  end
  source 'chef/handler/datadog'
  arguments(
    if respond_to?(:lazy)
      lazy { [handler_config] }
    else
      [handler_config]
    end
  )
  supports :report => true, :exception => true
  action :nothing
  only_if { node['datadog']['chef_handler_enable'] }
end.run_action(:enable)
