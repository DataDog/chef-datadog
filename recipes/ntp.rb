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

# Build a data structure with configuration.
# @note NTP check is enabled by default since datadog-agent 5.3.0.
# @see https://github.com/DataDog/integrations-core/blob/master/ntp/conf.yaml.default
# @example
#   node.override['datadog']['ntp']['instances'] = [
#     {
#       'offset_threshold' => '60',
#       'host' => 'pool.ntp.org',
#       'port' => 'ntp',
#       'version' => '3',
#       'timeout' => '5'
#     }
#   ]
datadog_monitor 'ntp' do
  instances node['datadog']['ntp']['instances']
  logs node['datadog']['ntp']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
