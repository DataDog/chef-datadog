include_recipe 'datadog::dd-agent'

# Monitor vault
#

datadog_monitor 'vault' do
  instances node['datadog']['vault']['instances']
  logs node['datadog']['vault']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
