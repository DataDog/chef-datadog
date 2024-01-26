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

# Monitor consul
#
# Assuming you have a consul instance on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# Note that the Agent only supports monitoring one Consul instance
#
# A few explanatory words:
#  - `catalog_checks`: Whether to perform checks against the Consul service Catalog
#  - `new_leader_checks`: Whether to enable new leader checks from this agent
#     Note: if this is set on multiple agents in the same cluster
#     you will receive one event per leader change per agent
#  - `service_whitelist`: Services to restrict catalog querying to
#    The default settings query up to 50 services. So if you have more than
#    this many in your Consul service catalog, you will want to fill in the
#    whitelist
#
# node['datadog']['consul']['instances'] = [
#   {
#     'url'               => 'http://localhost:8500',
#     'new_leader_checks' => false,
#     'catalog_checks'    => false,
#     'service_whitelist' => [],
#     'tags'              => [node.chef_environment]
#   }
# ]

datadog_monitor 'consul' do
  instances node['datadog']['consul']['instances']
  logs node['datadog']['consul']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
