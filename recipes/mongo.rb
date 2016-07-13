include_recipe 'datadog::dd-agent'

# Monitor mongo
#
# node.set['datadog']['mongo']['instances'] = [
#   {
#     'host' => 'localhost',
#     'port' => '27017'
#   }
# ]

datadog_monitor 'mongo' do
  instances node['datadog']['mongo']['instances']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
