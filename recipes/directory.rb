include_recipe 'datadog::dd-agent'

# Monitor files in a directory
#
# node['datadog']['directory']['instances'] = [
#   {
#     'directory' => "/path/to/directory",
#     'name' => 'tag_name',
#     'pattern' => '*.log",
#     'recursive' => true
#   }
# ]

datadog_monitor 'directory' do
  instances node['datadog']['directory']['instances']
  logs node['datadog']['directory']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
