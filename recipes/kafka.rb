include_recipe 'datadog::dd-agent'

# Monitor Kafka
#
# Set the following attributes
# * `instances` (required)
#   List of Kafka clusters to monitor. Each cluster is generally a dictionary with a `host`, `port` and a `name`.
#   More attributes are available. For more information, please refer to : https://github.com/DataDog/integrations-core/blob/master/kafka/conf.yaml.example
# * `version` (optional)
#   Select the appropriate configuration file template. Available options are:
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

datadog_monitor 'kafka' do
  instances node['datadog']['kafka']['instances']
  version node['datadog']['kafka']['version']
  logs node['datadog']['kafka']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
