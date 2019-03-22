include_recipe 'datadog::dd-agent'

# Monitor tcp
# @see http://docs.datadoghq.com/guides/network_checks/
#
# Assuming you have tcp connections you want to monitor
# you need to set up the following attributes
# node.datadog.tcp_check.instances = [
#   {
#     :name => "http",
#     :host => "localhost",
#     :port => 80
#   }
# ]

datadog_monitor 'tcp_check' do
  instances node['datadog']['tcp_check']['instances']
  logs node['datadog']['tcp_check']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
