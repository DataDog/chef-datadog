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

# Monitor Systemd
# It works for all unit types like targets, services, sockets, devices, mounts, automounts, swaps, paths, timers, snapshots, slices, scopes, busnames
# node.default['datadog']['systemd']['instances'] = [
#   {
#     'unit_names' => [
#       'myservice1.service',
#       'myservice2.service',
#       'mysocket.socket',
#       'mytimer.timer'
#     ],
#     'substate_status_mapping' => [
#       'services' => [
#         'myservice1' => {
#           'running' => 'ok',
#           'exited' => 'critical'
#         },
#         'myservice2' => {
#           'plugged' => 'ok',
#           'mounted' => 'ok',
#           'running' => 'ok',
#           'exited' => 'critical',
#           'stopped' => 'critical'
#         }
#       ],
#       'sockets' => [
#         'mysocket' => {
#           'running' => 'ok',
#           'exited' => 'critical'
#         }
#       ],
#       'timers' => [
#         'mytimer' => {
#          'running' => 'ok',
#          'exited' => 'critical'
#         }
#       ]
#     ],
#     'tags' => [
#       'mykey1:myvalue1',
#       'mykey2:myvalue2'
#     ]
#   }
# ]

datadog_monitor 'systemd' do
  instances node['datadog']['systemd']['instances']
  logs node['datadog']['systemd']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
