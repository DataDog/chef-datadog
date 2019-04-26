include_recipe 'datadog::dd-agent'

# Monitor tomcat
#
# Assuming you have 2 instances "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node.datadog.tomcat.instances = [
#   {
#     :server => "localhost",
#     :port => "7199",
#     :name => "prod",
#     :username => "username",
#     :password => "secret"
#   },
#   {
#     :server => "localhost",
#     :port => "8199",
#     :name => "test"
#   }
# ]

datadog_monitor 'tomcat' do
  instances node['datadog']['tomcat']['instances']
  logs node['datadog']['tomcat']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
