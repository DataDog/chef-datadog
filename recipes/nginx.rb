include_recipe "datadog::dd-agent"

datadog_ddmonitor "nginx" do
  instances node["datadog"]["nginx"]["instances"]
end
