include_recipe 'datadog::dd-agent'

# Monitor Cassandra

# Set the following attributes
# * `instances` (required)
#   List of Cassandra clusters to monitor. Each cluster is generally a dictionary with a `host`, `port` and a `name`.
#   More attributes are available. For more information, please refer to : https://github.com/DataDog/integrations-core/blob/master/cassandra/conf.yaml.example
# * `version` (optional)
#   Select the appropriate configuration file template. Available options are:
#   * `1` (Default, recommended for Cassandra < 2.2).
#     Use Cassandra legacy metrics, i.e. https://github.com/DataDog/dd-agent/blob/5.6.x/conf.d/cassandra.yaml.example#L23-L74
#   * `2` (recommended for existing Agent installs for Cassandra >= 2.2 and < 3.0).
#     Use Cassandra expanded metrics (CASSANDRA-4009) introduced in 1.2 (https://wiki.apache.org/cassandra/Metrics),
#     i.e. https://github.com/DataDog/integrations-core/blob/master/cassandra/conf.yaml.example#L23-L102
#   * `3` (recommended for Cassandra >= 3.0, and for new Agent installs for Cassandra >= 2.2).
#     Collect most Cassandra metrics to fully populate the default Cassandra dashboard on Datadog,
#     i.e. https://github.com/DataDog/integrations-core/blob/5.22.0/cassandra/conf.yaml.example#L35-L460

# Example:

# ```
# node['datadog']['cassandra'] =
#     instances: [
#     {
#         host: 'localhost',
#         port: 7199,
#         name: 'prod',
#         user: 'username',
#         password: 'secret'
#     },
#     {
#         server: 'localhost',
#         port: 8199,
#         name: 'test'
#     }],
#     version: 2
# }
# ```

datadog_monitor 'cassandra' do
  instances node['datadog']['cassandra']['instances']
  version node['datadog']['cassandra']['version']
  logs node['datadog']['cassandra']['logs']
end
