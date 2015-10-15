include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @see https://github.com/DataDog/dd-agent/blob/master/conf.d/postgres.yaml.example PostgreSQL Example
# @example
#   node.override['datadog']['postgres']['instances'] = [
#     {
#       'server' => "localhost",
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
# @todo Breaking, major version, convert `server` to `host` to match the check input.
# @todo Breaking, major version, convert template to yaml-style

datadog_monitor 'postgres' do
  instances node['datadog']['postgres']['instances']
end
