include_recipe '::dd-agent'

# node.default['datadog']['custom_log_collection']['logs'] = [
#   {
#     'type' => 'file',
#     'path' => '</path/to/logfile>',
#     'source' => '<source>',
#     'tags' => [
#       'tag1:value1',
#       'tag2:value2'
#     ]
#   }
# ]

datadog_monitor 'custom_log_collection' do
  logs node['datadog']['custom_log_collection']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
