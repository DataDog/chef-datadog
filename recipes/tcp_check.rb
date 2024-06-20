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

# Monitor tcp
# @see http://docs.datadoghq.com/guides/network_checks/
#
# Assuming you have tcp connections you want to monitor
# you need to set up the following attributes
# node.datadog.tcp_check.instances = [
#   {
#     :name => "http",
#     :host => "localhost",
#     :port => 80
#   }
# ]

datadog_monitor 'tcp_check' do
  instances node['datadog']['tcp_check']['instances']
  logs node['datadog']['tcp_check']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
