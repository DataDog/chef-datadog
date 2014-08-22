include_recipe "datadog::dd-agent"

datadog_monitor "sidekiq" do
  instances node["datadog"]["sidekiq"]["instances"]
end
