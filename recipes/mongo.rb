include_recipe 'datadog::dd-agent'

# Monitor mongo
#
# node.set['datadog']['mongo']['instances'] = [
#   {
#     'host' => 'localhost',
#     'port' => '27017',
#     'username' => 'someuser',
#     'password' => 'somepassword'
#   }
# ]

datadog_monitor 'mongo' do
  instances node['datadog']['mongo']['instances']
  logs node['datadog']['mongo']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
