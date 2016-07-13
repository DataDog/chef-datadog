include_recipe 'datadog::dd-agent'

datadog_monitor 'lighttpd' do
  instances node['datadog']['lighttpd']['instances']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
