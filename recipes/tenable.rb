include_recipe 'datadog::dd-agent'

# Monitor Tenable
#
# Here is the description of acceptable attributes:
# node.datadog.tenable = {
#   # logs - required: true
#   "logs" => nil,
# }

datadog_monitor 'tenable' do
  init_config node['datadog']['tenable']['init_config']
  instances node['datadog']['tenable']['instances']
  logs node['datadog']['tenable']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
