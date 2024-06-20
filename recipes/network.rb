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

# Monitor network
#
# node.override['datadog']['network']['instances'] = [
#   {
#     :collect_connection_state => "false",
#     :collect_count_metrics => "false",
#     :combine_connection_states => "true",
#     :excluded_interfaces => ["lo","lo0"]
#   },
# ]

Chef::Log.warn 'Datadog network check only supports one `instance`, please check attribute assignments' if node['datadog']['network']['instances'].count > 1

datadog_monitor 'network' do
  instances node['datadog']['network']['instances']
  logs node['datadog']['network']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
