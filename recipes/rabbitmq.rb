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

# Integrate rabbitmq metrics into Datadog
#
# Set up attributes following this example.
# If you are running multiple rabbitmq instances on the same machine
# list them all as hashes.
#
# node.datadog.rabbitmq.instances =
#   [
#     {
#       "api_url" => "http://localhost:15672/api/",
#       "user" => "guest",
#       "pass" => "guest",
#       "ssl_verify" => "true",
#       "tag_families" => "false"
#     }
#   ]

datadog_monitor 'rabbitmq' do
  instances node['datadog']['rabbitmq']['instances']
  logs node['datadog']['rabbitmq']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
