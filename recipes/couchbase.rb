include_recipe 'datadog::dd-agent'

# Integrate couchbase metrics into Datadog
#
# Set up attributes following this example.
# If you are running multiple couchbase instances on the same machine
# list them all as hashes.
#
# node.datadog.couchbase.instances = [
#                                    {
#                                      "server" => "http://localhost:8091",
#                                      "user" => "Administrator",
#                                      "password" => "password"
#                                    }
#                                   ]
datadog_monitor 'couchbase' do
  instances node['datadog']['couchbase']['instances']
end
