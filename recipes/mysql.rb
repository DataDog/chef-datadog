include_recipe 'datadog::dd-agent'

# Monitor mysql
#
# Assuming you have 1 mysql instance "prod"  on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['mysql']['instances'] = [
#   {
#     'server' => "localhost",
#     'user' => "my_username",
#     'pass' => "my_password",
#     'tags' => ["prod"],
#     'options' => [
#       "replication: 0",
#       "galera_cluster: 1"
#     ]
#   },
# ]

package 'python-mysql' do
  case node['platform_family']
  when 'debian'
    package_name 'python-mysqldb'
  when 'rhel'
    package_name 'MySQL-python'
  end
  action :install
end

datadog_monitor 'mysql' do
  instances node['datadog']['mysql']['instances']
end
