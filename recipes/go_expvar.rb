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

# Monitor Go metrics exported via expvar
#  node['datadog']['go_expvar']['instances'] = [
#   {
#     'expvar_url' => 'http://localhost:8080/debug/vars',
#     'tags' => [
#        'application:my_go_app'
#      ],
#     'metrics' => [
#       {
#         'path' => 'test_metrics_name_1', 'alias' => 'go_expvar.test_metrics_name_1', 'type' => 'gauge'
#       },
#       {
#         'path' => 'test_metrics_name_2', 'alias' => 'go_expvar.test_metrics_name_2', 'type' => 'gauge', 'tags' => ['tag1', 'tag2']
#       }
#     ]
#   }
#  ]

datadog_monitor 'go_expvar' do
  init_config node['datadog']['go_expvar']['init_config']
  instances node['datadog']['go_expvar']['instances']
  logs node['datadog']['go_expvar']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
