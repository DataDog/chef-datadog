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

# Monitor the Windows Event Log
# @see https://github.com/DataDog/integrations-core/blob/master/win32_event_log/datadog_checks/win32_event_log/data/conf.yaml.example for details
#
# @example
#   node['datadog']['win32_event_log']['init_config'] = {
#     'tag_event_id'      => false                    # optional, defaults to false
#   }
#   node['datadog']['win32_event_log']['instances'] = [
#     {
#       'log_file'          => ['Application'],
#       'source_name'       => ['MSSQLSERVER'],
#       'type'              => ['Warning', 'Error'],
#       'message_filters'   => ['%error%'],
#       'tags'              => ['sqlserver']
#      }
#   ]

datadog_monitor 'win32_event_log' do
  init_config node['datadog']['win32_event_log']['init_config']
  instances node['datadog']['win32_event_log']['instances']
  logs node['datadog']['win32_event_log']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
