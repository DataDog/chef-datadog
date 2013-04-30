include_recipe "datadog::dd-agent"

datadog_ddmonitor "lighttpd" do
  instances node["datadog"]["lighttpd"]["instances"]
end
