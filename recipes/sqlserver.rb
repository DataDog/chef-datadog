include_recipe 'datadog::dd-agent-config'

# Integrate SQL Server metrics
#
# Simply declare the following attributes
# One instance per server.
#
# node['datadog']['sqlserver']['custom_metrics'] = [
#                               {
#                                 "name" => "sqlserver.db.commit_table_entries",
#                                 "type" => "gauge",
#                                 "counter_name" => "Log Flushes/sec",
#                                 "instance_name" => "ALL",
#                                 "tag_by" => "db"
#                               }
#                              ]
# node['datadog']['sqlserver']['instances'] = [
#                               {
#                                 "host" => "other.server.com",
#                                 "port" => 12345,
#                                 "username" => "myuser",
#                                 "password" => "password"
#                               }
#                              ]

config = { 'custom_metrics' => node['datadog']['sqlserver']['custom_metrics'] } if node['datadog']['sqlserver'].key?('custom_metrics')
datadog_monitor 'sqlserver' do
  instances 	node['datadog']['sqlserver']['instances']
  init_config 	config
end
