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
# @see https://github.com/DataDog/integrations-core/blob/master/php_fpm/conf.yaml.example PHP-FPM Example
# @example
#   node.override['datadog']['php_fpm']['instances'] = [
#     {
#       'status_url' => 'http://localhost/status',
#       'ping_url' => 'http://localhost/ping',
#       'ping_reply' => 'pong',
#       'user' => 'bits',
#       'password' => 'D4T4D0G',
#       'tags' => ['prod']
#     }
#   ]
datadog_monitor 'php_fpm' do
  instances node['datadog']['php_fpm']['instances']
  logs node['datadog']['php_fpm']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
