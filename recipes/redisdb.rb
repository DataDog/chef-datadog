include_recipe "datadog::dd-agent"

# Monitor redis
#
# Assuming you have 1 instance "prod"  on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['redisdb']['instances'] = [
#   {
#     'server' => "localhost",
#     'port' => 6379,
#     'password' => "my_password",
#     'tags' => ["prod"],
#   }
# ]

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
