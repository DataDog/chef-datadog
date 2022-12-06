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

# Monitor processes
#
#    name:          (mandatory) STRING Is the display name of the check
#    search_string: (mandatory) LIST OF STRINGS The strings to search for in process names. If
#                               one of these matches a process's name, that process will be
#                               included in the stats.
#    exact_match:   (optional)  True/False, defaults to True, if you want to look for a partial
#                               match, use exact_match: "False", otherwise use the exact base
#                               name of the process.
#
# Example:
#
# node.datadog.process.instances = [
#   {
#     :name => "ssh",
#     :search_string => ["ssh","sshd"],
#     :exact_match => "False",
#   },
#   {
#     :name => "postgres",
#     :search_string => ["postgres"],
#   },
# ]

datadog_monitor 'process' do
  instances node['datadog']['process']['instances']
  logs node['datadog']['process']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
