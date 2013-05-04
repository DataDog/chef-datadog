include_recipe "datadog::dd-agent"

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
