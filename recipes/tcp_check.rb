include_recipe "datadog::dd-agent"

datadog_monitor "tcp_check" do
  instances node["datadog"]["tcp_check"]["instances"]
end
