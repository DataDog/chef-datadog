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

# Monitor dns
#
# Create one attribute entry for each combination of hostname that
# you want to monitor + DNS server that you want to monitor it on.
#
# node['datadog']['dns_check']['instances'] = [
#   {
#     'hostname' => 'foo.example.com',
#     'nameserver' => 'prod-ns.example.com',
#     'timeout' => 1
#   },
#   {
#     'hostname' => 'baz.example.com',
#     'nameserver' => 'prod-ns.example.com',
#     'timeout' => 1
#   },
#   {
#     'hostname' => 'foo.example.com',
#     'nameserver' => 'test-ns.example.com',
#     'timeout' => 3
#   },
#   {
#     'hostname' => 'quux.example.com',
#     'nameserver' => 'test-ns.example.com',
#     'timeout' => 3
#   },
# ]

datadog_monitor 'dns_check' do
  instances node['datadog']['dns_check']['instances']
  logs node['datadog']['dns_check']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
