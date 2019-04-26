include_recipe 'datadog::dd-agent'

datadog_monitor 'lighttpd' do
  instances node['datadog']['lighttpd']['instances']
  logs node['datadog']['lighttpd']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
