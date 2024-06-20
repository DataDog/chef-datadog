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
# Set the following attributes
# * `instances` (required)
#   List of Kafka clusters to monitor. Each cluster is generally a dictionary with a `host`, `port` and a `name`.
#   More attributes are available. For more information, see https://github.com/DataDog/integrations-core/blob/master/kafka/datadog_checks/kafka/data/conf.yaml.example
# * `conf` (optional)
#   List of metrics to be collected. For more information, see https://github.com/DataDog/integrations-core/blob/master/kafka/datadog_checks/kafka/data/conf.yaml.example
# * `version` (optional)
#   Only used if `conf` is not set, allows you to use a pre-defined conf template. Available options are:
#   * `1` (Default, Kafka < 0.8.2).
#   * `2` (Kafka >= 0.8.2).

# Example:

# Assuming you have 2 clusters "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node.datadog.kafka.instances = [
#   {
#     :host => "localhost",
#     :port => "9999",
#     :name => "prod",
#     :user => "username",
#     :password => "secret"
#   },
#   {
#     :host => "localhost",
#     :port => "8199",
#     :name => "test"
#   }
# ]
#
#
#
#

template_version = node['datadog']['kafka']['conf'].nil? ? node['datadog']['kafka']['version'] : 3

datadog_monitor 'kafka' do
  instances node['datadog']['kafka']['instances']
  version template_version
  init_config({ :is_jmx => true, :conf => node['datadog']['kafka']['conf'] })
  logs node['datadog']['kafka']['logs']
  action :add
  use_integration_template template_version == 3
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
