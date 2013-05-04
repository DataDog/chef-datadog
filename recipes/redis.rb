include_recipe "datadog::dd-agent"

# same name across distributions
package "python-redis" do
  action "install"
end

# We need version >= 2.4.10
easy_install_package "redis" do
  action "install", "upgrade"
  not_if "python -c \"import redis; print map(int, redis.__version__.split('.')) >= [2, 4, 10]\""
end

datadog_monitor "redis" do
  instances node["datadog"]["redis"]["instances"]
end
