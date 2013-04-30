include_recipe "datadog::dd-agent"

datadog_ddmonitor "mongo" do
  instances node["datadog"]["mongo"]["instances"]
end
