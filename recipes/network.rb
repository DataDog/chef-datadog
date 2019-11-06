include_recipe 'datadog::dd-agent'

# Monitor network
#
# node.override['datadog']['network']['instances'] = [
#   {
#     :collect_connection_state => "false",
#     :collect_count_metrics => "false",
#     :combine_connection_states => "true",
#     :excluded_interfaces => ["lo","lo0"]
#   },
# ]

Chef::Log.warn 'Datadog network check only supports one `instance`, please check attribute assignments' if node['datadog']['network']['instances'].count > 1

datadog_monitor 'network' do
  instances node['datadog']['network']['instances']
  logs node['datadog']['network']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
