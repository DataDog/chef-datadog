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

# Monitor weblogic
#
# Assuming you have 2 instances "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node.datadog.weblogic.instances = [
#   {
#     :host => "localhost",
#     :port => "9090",
#     :name => "prod",
#     :username => "username",
#     :password => "secret"
#   },
#   {
#     :host => "localhost",
#     :port => "9091",
#     :name => "test"
#   }
# ]

datadog_monitor 'weblogic' do
  init_config node['datadog']['weblogic']['init_config']
  instances node['datadog']['weblogic']['instances']
  logs node['datadog']['weblogic']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
