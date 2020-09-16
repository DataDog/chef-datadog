include_recipe 'datadog::dd-agent'

# Monitor flink
#
# Here is the description of acceptable attributes:
# node.datadog.flink = {
#   # logs - required: false
#   "logs" => nil,
# }

datadog_monitor 'flink' do
  init_config node['datadog']['flink']['init_config']
  instances node['datadog']['flink']['instances']
  logs node['datadog']['flink']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
