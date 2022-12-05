# Copyright:: 2011-Present, Datadog
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

include_recipe '::dd-agent'

# Monitor kubernetes
#
# Assuming you have a kubernetes instance on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['kubernetes']['instances'] = [
#   {
#     'host'           => 'localhost',
#     'port'           => 4194,
#     'method'         => 'http',
#     'kubelet_port'   => 10255,
#     'namespace'      => 'default'
#     'collect_events' => false,
#     'use_histogram'  => false,
#     'enabled_rates'  => [
#       'cpu.*',
#       'network.*'
#     ],
#     'enabled_gauges' => [
#       'filesystem.*'
#     ]
#   }
# ]

datadog_monitor 'kubernetes' do
  instances node['datadog']['kubernetes']['instances']
  logs node['datadog']['kubernetes']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
