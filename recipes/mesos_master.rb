#
# Cookbook Name:: datadog
# Recipe:: mesos
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
# @example
#   node.override['datadog']['mesos_master'] =
#     instances: [{
#       url: 'http://server:port',
#       timeout: 8
#     }],
#     init_config: {
#       default_timeout: 10
#     }

datadog_monitor 'mesos_master' do
  if node['datadog'].has_key?('mesos_master') then
    init_config node['datadog']['mesos_master']['init_config']
    instances node['datadog']['mesos_master']['instances']
  end
end
