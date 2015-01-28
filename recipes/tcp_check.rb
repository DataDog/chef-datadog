include_recipe 'datadog::dd-agent'

# Monitor tcp
#
# Assuming you have tcp connections you want to monitor
# you need to set up the following attributes
# node.datadog.tcp_check.instances = [
#                                     {
#                                       :name => "port1",
#                                       :host => "localhost",
#                                       :port => 80
#                                     },
#                                     {
#                                       :name => "port2"
#                                       :host => "localhost",
#                                       :port => 8080
#                                     }
#                                    ]

datadog_monitor 'tcp_check' do
  instances node['datadog']['tcp_check']['instances']
  init_config node['datadog']['tcp_check']['init_config'] if node['datadog']['tcp_check'].include?('init_config')
end
