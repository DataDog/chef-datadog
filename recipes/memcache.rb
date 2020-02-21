include_recipe 'datadog::dd-agent'

# Integrate memcache metrics into Datadog
#
# Simply set up attributes following this example.
# If you are running multiple memcache instances on the same machine
# list them all as hashes.
#
# node.datadog.memcache.instances = [
#                                    {
#                                      "url" => "localhost",
#                                      "port" => "11211",
#                                      "tags" => ["prod", "aws"],
#                                      "options" => [
#                                        "items: false",
#                                        "slabs: false"
#                                      ]
#                                    }
#                                   ]

datadog_monitor 'mcache' do
  instances node['datadog']['memcache']['instances']
  logs node['datadog']['memcache']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
