include_recipe 'datadog::dd-agent'

# Copied from nginx recipe

datadog_monitor 'rails' do
  instances node['datadog']['rails']['instances']
  logs node['datadog']['rails']['logs']
end