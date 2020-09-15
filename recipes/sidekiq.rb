include_recipe 'datadog::dd-agent'

# Monitor Sidekiq
#
# Here is the description of acceptable attributes:
# node.datadog.sidekiq = {
#   # logs - required: false
#   "logs" => nil,
# }

datadog_monitor 'sidekiq' do
  init_config node['datadog']['sidekiq']['init_config']
  instances node['datadog']['sidekiq']['instances']
  logs node['datadog']['sidekiq']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
