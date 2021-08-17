include_recipe '::dd-agent'

# Build a data structure with configuration.
# @see https://github.com/DataDog/integrations-core/blob/master/postgres/conf.yaml.example PostgreSQL Example
# @example
#   node.override['datadog']['postgres']['instances'] = [
#     {
#       'host' => "/var/run/postgresql/.s.PGSQL.5432",
#       'username' => "datadog"
#     },
#     {
#       'host' => "localhost",
#       'port' => "5432",
#       'username' => "datadog",
#       'tags' => ["test"]
#     },
#     {
#       'server' => "remote",
#       'port' => "5432",
#       'username' => "datadog",
#       'tags' => ["prod"],
#       'dbname' => 'my_database',
#       'ssl' => true,
#       'relations' => ["apple_table", "orange_table"]
#     }
#   ]
# @note While you can use either `server` or `host` values, prefer `host`.
# @todo Breaking, major version, convert `server` to `host` to match the check input.

datadog_monitor 'postgres' do
  instances node['datadog']['postgres']['instances']
  logs node['datadog']['postgres']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
