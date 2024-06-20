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

# Integrate IIS metrics
#
# Simply declare the following attributes
# One instance per server.
#
# node.datadog.iis.instances = [
#                               {
#                                 "host" => "localhost",
#                                 "tags" => ["prod", "other_tag"],
#                                 "sites" => ["Default Web Site"]
#                               },
#                               {
#                                 "host" => "other.server.com",
#                                 "username" => "myuser",
#                                 "password" => "password",
#                                 "tags" => ["prod", "other_tag"]
#                               }
#                              ]

datadog_monitor 'iis' do
  instances node['datadog']['iis']['instances']
  logs node['datadog']['iis']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
