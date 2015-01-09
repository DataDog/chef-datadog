include_recipe 'datadog::windows'

# Integrate IIS metrics
#
# Simply declare the following attributes
# One instance per server.
#
# node.datadog.iis.instances = [
#                               {
#                                 "host" => "localhost",
#                                 "tags" => ["prod", "other_tag"]
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
end
