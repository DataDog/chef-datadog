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

# Build a data structure with configuration.
# @see http://docs.datadoghq.com/guides/network_checks/
# @example
#   node.override['datadog']['http_check']['instances'] = [
#     {
#       'name' => 'MyHTTPcheck',
#       'url' => 'http://my.server/some/service',
#       'timeout' => '15',
#       'content_match' => 'string to match',
#       'include_content' => true,
#       'collect_response_time' => true,
#       'tags' => [
#        'myApp',
#        'serviceName'
#       ]
#     }
# ]

datadog_monitor 'http_check' do
  instances node['datadog']['http_check']['instances']
  logs node['datadog']['http_check']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
