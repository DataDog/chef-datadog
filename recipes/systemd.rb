include_recipe 'datadog::dd-agent'

# Monitor Systemd
#
# node.default['datadog']['systemd']['instances'] = [
#   {
#     'unit_names' => [
#       'myservice1.service',
#       'myservice2.service',
#       'mysocket.socket'
#     ],
#     'substate_status_mapping' => [
#       'services' => [
#         'myservice1' => {
#           'running' => 'ok',
#           'exited' => 'critical'
#         },
#         'myservice2' => {
#           'plugged' => 'ok',
#           'mounted' => 'ok',
#           'running' => 'ok',
#           'exited' => 'critical',
#           'stopped' => 'critical'
#         }
#       ],
#       'sockets' => [
#         'mysocket' => {
#           'running' => 'ok',
#           'exited' => 'critical'
#         }
#       ]
#     ],
#     'tags' => [
#       'mykey1:myvalue1',
#       'mykey2:myvalue2'
#     ]
#   }
# ]

datadog_monitor 'systemd' do
  instances node['datadog']['systemd']['instances']
  logs node['datadog']['systemd']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
