include_recipe "datadog::dd-agent"
package "python-mysql" do
  case node['platform']
  when "centos", "redhat", "fedora", "suse"
    package_name "MySQL-python"
  when "debian", "ubuntu"
    package_name "python-mysqldb"
  end
  action :install
end
datadog_ddmonitor "mysql"
