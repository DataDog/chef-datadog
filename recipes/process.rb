include_recipe 'datadog::dd-agent'

# Monitor process
# @see http://docs.datadoghq.com/integrations/process/

datadog_monitor 'process' do
  instances node['datadog']['process']['instances']
end
