include_recipe 'datadog::dd-agent'

# Monitor flink
#
# Here is the description of acceptable attributes:
# node.datadog.flink = {
#   # logs - required: false
#   "logs" => nil,
# }

datadog_monitor 'flink' do
  instances node['datadog']['flink']['instances']
  logs node['datadog']['flink']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
