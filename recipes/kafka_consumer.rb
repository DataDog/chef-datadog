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
