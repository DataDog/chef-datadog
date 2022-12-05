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
# @see https://github.com/DataDog/integrations-core/blob/master/postgres/conf.yaml.example PostgreSQL Example
# @example
#   node.override['datadog']['postgres']['instances'] = [
#     {
#       'host' => "/var/run/postgresql/.s.PGSQL.5432",
#       'username' => "datadog"
#     },
#     {
#       'host' => "localhost",
#       'port' => "5432",
#       'username' => "datadog",
#       'tags' => ["test"]
#     },
#     {
#       'server' => "remote",
#       'port' => "5432",
#       'username' => "datadog",
#       'tags' => ["prod"],
#       'dbname' => 'my_database',
#       'ssl' => true,
#       'relations' => ["apple_table", "orange_table"]
#     }
#   ]
# @note While you can use either `server` or `host` values, prefer `host`.
# @todo Breaking, major version, convert `server` to `host` to match the check input.

datadog_monitor 'postgres' do
  instances node['datadog']['postgres']['instances']
  logs node['datadog']['postgres']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
