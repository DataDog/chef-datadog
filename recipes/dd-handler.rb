#
# Cookbook Name:: datadog
# Recipe:: dd-handler
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

# Chef 12 sets the SSL_CERT_FILE env var internally so that it works for Chef code
# but Datadog doesn't pick it up. It's set using / as the path separator
# we'll use this to detect that it isn't set in Windows and set it so that DD works
if platform_family?('windows') && ENV['SSL_CERT_FILE'].include?('/')
	env 'SSL_CERT_FILE' do
		value	ENV['SSL_CERT_FILE'].gsub('/', '\\')
	end
	
	# we can't run the handler on this run as the env change doesn't take effect
	Chef::Log.warn 'Disabling datadog handler on this run as SSL cert file won''t exist yet'
	node.default['datadog']['chef_handler_enable'] = false
end

include_recipe 'chef_handler'
ENV['DATADOG_HOST'] = node['datadog']['url']

chef_gem 'chef-handler-datadog' do
  action :install
  version node['datadog']['chef_handler_version']
end
require 'chef/handler/datadog'

# Create the handler to run at the end of the Chef execution
chef_handler 'Chef::Handler::Datadog' do
  source 'chef/handler/datadog'
  arguments [
    :api_key => node['datadog']['api_key'],
    :application_key => node['datadog']['application_key'],
    :use_ec2_instance_id => node['datadog']['use_ec2_instance_id']
  ]
  supports :report => true, :exception => true
  action :nothing
end.run_action(:enable) if node['datadog']['chef_handler_enable']
