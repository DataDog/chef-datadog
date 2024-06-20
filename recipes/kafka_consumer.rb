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

# Monitor Kafka
#
# You need to set up the following attributes
# node.datadog.kafka_consumer.instances = [
#   {
#     :kafka_connect_str => "localhost:19092",
#     :consumer_groups => {
#     :my_consumer => {
#       :my_topic => [<partition>, <partition>, <partition>, <partition>]
#     } ,
#     # optional -if consumer_groups is set do false no matter of it's set to true or not.
#     # false is the default configuration, but since there is a dependency on consumer_groups
#     # it will be added to conf.yaml as false.
#     :monitor_unlisted_consumer_groups >> true,
#     :zk_connect_str => "localhost:2181",
#     :zk_prefix => "/0.8",
#     # optional -if it's set to false it will no added to conf.yaml because false is default.
#     :kafka_consumer_offsets => true
#   }
# ]

datadog_monitor 'kafka_consumer' do
  instances node['datadog']['kafka_consumer']['instances']
  logs node['datadog']['kafka_consumer']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
