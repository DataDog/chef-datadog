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

# Monitor haproxy

# You need to set up the following attributes
# node.datadog.haproxy.instances = [
#                                     {
#                                       :url => "http://localhost/stats_url",
#                                       :username => "username",
#                                       :password => "secret",
#                                       :status_check => false,
#                                       :collect_aggregates_only => true,
#                                       :collect_status_metrics => true
#                                     }
#                                    ]

datadog_monitor 'haproxy' do
  instances node['datadog']['haproxy']['instances']
  logs node['datadog']['haproxy']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
