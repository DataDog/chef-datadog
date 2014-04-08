include_recipe "datadog::dd-agent"

# Monitor postgres
#
# Simply declare the following attributes
# One instance per server.
#
# node['datadog']['postgres']['instances'] = [
#   {
#     'host' => "localhost",
#     'port' => "5432",
#     'username' => "datadog",
#     'tags' => ["test"]
#   },
#   {
#     'host' => "remote",
#     'port' => "5432",
#     'username' => "datadog",
#     'tags' => ["prod"],
#     'dbname' => 'my_database',
#     'relations' => ["apple_table", "orange_table"]
#   }
# ]

package "psycopg2" do
  case node["platform_family"]
  when "debian"
    package_name "python-psycopg2"
  when "rhel"
    package_name "python-psycopg2"
  end
  action :install
end

datadog_monitor "postgres" do
  instances node["datadog"]["postgres"]["instances"]
end
