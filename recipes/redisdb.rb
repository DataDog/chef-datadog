include_recipe "datadog::dd-agent"

# same name across distributions
case node["platform_family"]
when "debian"
  package "python-redis"
when "rhel"
  easy_install_package "redis"
end

datadog_monitor "redisdb" do
  instances node["datadog"]["redisdb"]["instances"]
end
