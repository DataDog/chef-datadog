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

# Monitor couchDB
#
# Assuming you have 2 instances on the same host
# you need to set up the following attributes.
# Each instance's metric will be tagged with "instance:server_url".
# to help you differentiate between instances.
# NOTE the "couch" instead of "couchdb" attribute.
#
# node['datadog']['couch']['instances'] = [
#                                 {
#                                  server: 'http://localhost:1234'
#                                 },
#                                 {
#                                  server: 'http://localhost:4567'
#                                 }
#                                ]

datadog_monitor 'couch' do
  init_config nil
  instances node['datadog']['couch']['instances']
  logs node['datadog']['couch']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
