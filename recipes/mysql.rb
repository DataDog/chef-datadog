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

# Monitor mysql
#
# Assuming you have 1 mysql instance "prod"  on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['mysql']['instances'] = [
#   {
#     'server' => "localhost",
#     'port' => 3306,
#     'user' => "my_username",
#     'pass' => "my_password",
#     'sock' => "/path/to/mysql.sock",
#     'tags' => ["prod"],
#     'options' => [
#       "replication: 0",
#       "galera_cluster: 1"
#     ],
#     'queries' => [
#       {
#         'type' => 'gauge',
#         'field' => 'users_count'
#         'metric' => 'my_app.my_users.count',
#         'query' => 'SELECT COUNT(1) AS users_count FROM users'
#       },
#     ]
#   },
# ]

datadog_monitor 'mysql' do
  instances node['datadog']['mysql']['instances']
  logs node['datadog']['mysql']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
