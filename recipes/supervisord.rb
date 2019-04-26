#
# Cookbook Name:: datadog
# Recipe:: supervisord
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
include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @see https://github.com/DataDog/integrations-core/blob/master/supervisord/conf.yaml.example Supervisord Example
# @example
#   node.override['datadog']['supervisord']['instances'] = [
#     {
#       name: 'server0',
#       socket: 'unix:///var/run/default-supervisor.sock'
#     },
#     {
#       name: 'server1',
#       host: 'localhost',
#       port: '9001',
#       user: 'user',
#       pass: 'pass',
#       proc_names: [
#         'apache2',
#         'webapp'
#       ]
#     }
#   ]

datadog_monitor 'supervisord' do
  instances node['datadog']['supervisord']['instances']
  logs node['datadog']['supervisord']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
