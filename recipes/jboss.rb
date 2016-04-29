#
# Cookbook Name:: datadog
# Recipe:: jboss
#
# Copyright 2011-2016, Datadog
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
#
include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @example
#   node.override['datadog']['jboss']['init_config'] = {
#     "is_jmx": "true",
#     "custom_jar_paths": "/path/to/jboss-cli-client.jar"
#   }
#
#   node.override['datadog']['jboss']['instances'] = [
#     {
#       "host": "localhost",
#       "port": "9999",
#       "include": {
#         "bean": "jboss.as:subsystem=web,connectory=http",
#       "attribute": {
#         "processingTime": {
#           "alias": "processingTime",
#           "metric_type": "gauge"
#          }
#       }
#     }
#   ]

datadog_monitor 'jboss' do
  init_config node['datadog']['jboss']['init_config']
  instances node['datadog']['jboss']['instances']
end
