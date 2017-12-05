include_recipe 'datadog::dd-agent'

# Monitor SSH connectivity
#
# Assuming you have SSH connections you want to monitor, you will need to set
# up the following attributes at some point in your Chef run, in either a role
# or another cookbook.
#
# node['datadog']['ssh_check']['instances'] = [
#   {
#     'host'              => '1.2.3.4',               # required for each instance
#     'username'          => 'user',                  # required for each instance
#     'password'          => 'password',              # optional
#     'port'              => 22,                      # optional, defaults to 22
#     'sftp_check'        => true,                    # optional, defaults to true
#     'private_key_file'  => '/path/to/key',          # optional
#     'add_missing_keys'  => false,                   # optional, defaults to false
#     'tags'              => [node.chef_environment]  # optional
#   }
# ]

datadog_monitor 'ssh_check' do
  instances node['datadog']['ssh_check']['instances']
  logs node['datadog']['ssh_check']['logs']
end
