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
  # chef_handler 1.1 needs us to require datadog handler's file,
  # which makes why-run runs fail when chef-handler-datadog is not installed,
  # so skip the recipe when in why-run mode until we can use chef_handler 1.2
  Chef::Log.warn('Running in why-run mode, skipping dd-handler')
  return
end

include_recipe 'chef_handler'
ENV['DATADOG_HOST'] = node['datadog']['url']

chef_gem 'chef-handler-datadog' do # ~FC009
  action :install
  version node['datadog']['chef_handler_version']
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
  def handler_config # rubocop:disable Metrics/AbcSize
    config = {
      :api_key => Chef::Datadog.api_key(node),
      :application_key => Chef::Datadog.application_key(node),
      :use_ec2_instance_id => node['datadog']['use_ec2_instance_id'],
      :tag_prefix => node['datadog']['tag_prefix']
    }
    unless node['datadog']['use_ec2_instance_id']
      config[:hostname] = node['datadog']['hostname']
    end
    config
  end

  require 'chef/handler/datadog'
  source 'chef/handler/datadog'
  arguments(
    if respond_to?(:lazy)
      lazy { [handler_config] }
    else
      [handler_config]
    end
  )
  supports :report => true, :exception => true
  action(
    if node['datadog']['chef_handler_enable']
      :enable
    else
      :nothing
    end
  )
end
