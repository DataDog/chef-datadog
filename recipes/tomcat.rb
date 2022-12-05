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

# Monitor tomcat
#
# Assuming you have 2 instances "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node.datadog.tomcat.instances = [
#   {
#     :server => "localhost",
#     :port => "7199",
#     :name => "prod",
#     :username => "username",
#     :password => "secret"
#   },
#   {
#     :server => "localhost",
#     :port => "8199",
#     :name => "test"
#   }
# ]

datadog_monitor 'tomcat' do
  instances node['datadog']['tomcat']['instances']
  logs node['datadog']['tomcat']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
