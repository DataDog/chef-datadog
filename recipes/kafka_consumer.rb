include_recipe '::dd-agent'

# Monitor Kafka
#
# You need to set up the following attributes
# node.datadog.kafka_consumer.instances = [
#   {
#     :kafka_connect_str => "localhost:19092",
#     :zk_connect_str => "localhost:2181",
#     :zk_prefix => "/0.8"
#   }
# ]

datadog_monitor 'kafka_consumer' do
  instances node['datadog']['kafka_consumer']['instances']
  logs node['datadog']['kafka_consumer']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
