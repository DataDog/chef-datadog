include_recipe 'datadog::dd-agent'

# Monitor kubernetes
#
# Assuming you have a kubernetes instance on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['kubernetes']['instances'] = [
#   {
#     'host'           => 'localhost',
#     'port'           => 4194,
#     'method'         => 'http',
#     'kubelet_port'   => 10255,
#     'namespace'      => 'default'
#     'collect_events' => false,
#     'use_histogram'  => false,
#     'enabled_rates'  => [
#       'cpu.*',
#       'network.*'
#     ],
#     'enabled_gauges' => [
#       'filesystem.*'
#     ]
#   }
# ]

datadog_monitor 'kubernetes' do
  instances node['datadog']['kubernetes']['instances']
  logs node['datadog']['kubernetes']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
