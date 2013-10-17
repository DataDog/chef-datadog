include_recipe "datadog::dd-agent"

# same name across distributions
case node["platform_family"]
when "debian"
  package "python-redis"
when "rhel"
  easy_install_package "redis"
end

# We need version >= 2.4.10
easy_install_package "redis" do
  action "install"
  not_if "python -c \"import redis; print map(int, redis.__version__.split('.')) >= [2, 4, 10]\" | grep True"
end

datadog_monitor "redisdb" do
  instances node["datadog"]["redisdb"]["instances"]
end
