include_recipe '::dd-agent'

# Monitor Systemd
# It works for all unit types like target, service, socket, device, mount, automount, swap, path, timer, snapshot, slice, scope, busname
# node.default['datadog']['systemd']['instances'] = [
#   {
#     'unit_names' => [
#       'myservice1.service',
#       'myservice2.service',
#       'mysocket.socket',
#       'mytimer.timer'
#     ],
#     'substate_status_mapping' => [
#       'service' => [
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
#       'socket' => [
#         'mysocket' => {
#           'running' => 'ok',
#           'exited' => 'critical'
#         }
#       ],
#       'timer' => [
#         'mytimer' => {
#          'running' => 'ok',
#          'exited' => 'critical'
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
