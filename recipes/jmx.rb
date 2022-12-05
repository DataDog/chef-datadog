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
# @see https://github.com/DataDog/dd-agent/blob/master/conf.d/jmx.yaml.example JMX Example
# @example
#   node.override['datadog']['jmx']['instances'] = [
#     {
#       'host' => 'localhost',
#       'port' => 7199,
#       'name' 'prod_jmx_app',
#       'conf' => [
#         'include' => {
#           'attribute' => ['Capacity', 'Used'],
#           'bean_name' => 'com.datadoghq.test:type=BeanType,tag1=my_bean_name',
#           'domain' => 'com.datadoghq.test'
#         }
#       ]
#     }
#   ]
datadog_monitor 'jmx' do
  instances node['datadog']['jmx']['instances']
  logs node['datadog']['jmx']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
