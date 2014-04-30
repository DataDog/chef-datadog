include_recipe "datadog::dd-agent"

datadog_monitor "http_check" do
  instances node["datadog"]["http_check"]["instances"]
end
