#
# Cookbook:: datadog
# Recipe:: hdfs
#
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

# Monitor hdfs
#
# Assuming you have 2 instances "prod" and "test", you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node["datadog"]["hdfs"]["instances"] = [
#   {
#     "fqdn" => "hdfs.prod.tld",
#     "port" => "8020",
#     "tags" => ["prod", "hdfs_core"]
#   },
#   {
#     "fqdn" => "hdfs.test.tld",
#     "port" => "8020",
#     "tags" => ["test"]
#   }
# ]

include_recipe '::dd-agent'

datadog_monitor 'hdfs' do
  instances node['datadog']['hdfs']['instances']
  logs node['datadog']['hdfs']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
