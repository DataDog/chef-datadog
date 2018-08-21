include_recipe 'datadog::dd-agent'

# Monitor vault
#

datadog_monitor 'vault' do
  instances node['datadog']['vault']['instances']
  logs node['datadog']['vault']['logs']
end
