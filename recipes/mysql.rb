include_recipe "datadog::dd-agent"

package "python-mysql" do
  case node['platform_family']
  when "debian"
    package_name "python-mysqldb"
  when "rhel"
    package_name "MySQL-python"
  end
  action :install
end
datadog_ddmonitor "mysql"
