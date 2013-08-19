include_recipe "datadog::dd-agent"

# Monitor network
# 
# node.datadog.network.instances = [
#   {
#     :collect_connection_state => "false",
#     :excluded_interfaces => ["lo","lo0"]
#   },
# ]

datadog_monitor "network" do
  instances node["datadog"]["network"]["instances"]
end
