include_recipe 'datadog::dd-agent'

# Integrate IIS metrics
#
# Simply declare the following attributes
# One instance per server.
#
# node.datadog.iis.instances = [
#                               {
#                                 "host" => "localhost",
#                                 "tags" => ["prod", "other_tag"],
#                                 "sites" => ["Default Web Site"]
#                               },
#                               {
#                                 "host" => "other.server.com",
#                                 "username" => "myuser",
#                                 "password" => "password",
#                                 "tags" => ["prod", "other_tag"]
#                               }
#                              ]

datadog_monitor 'iis' do
  instances node['datadog']['iis']['instances']
  logs node['datadog']['iis']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
