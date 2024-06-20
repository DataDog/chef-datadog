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

# Monitor mongo
#
# node.set['datadog']['mongo']['instances'] = [
#   {
#     'host' => 'localhost',
#     'port' => '27017',
#     'username' => 'someuser',
#     'password' => 'somepassword'
#   }
# ]

datadog_monitor 'mongo' do
  instances node['datadog']['mongo']['instances']
  logs node['datadog']['mongo']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
