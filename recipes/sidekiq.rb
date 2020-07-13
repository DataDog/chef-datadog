include_recipe 'datadog::dd-agent'

# Monitor Sidekiq
#
# Here is the description of acceptable attributes:
# node.datadog.sidekiq = {
#   # logs - required: false
#   "logs" => nil,
# }

datadog_monitor 'sidekiq' do
  instances node['datadog']['sidekiq']['instances']
  logs node['datadog']['sidekiq']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
