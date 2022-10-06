include_recipe '::dd-agent'

# All attributes are optional.
# node.default['datadog']['gearmand']['instances'] = [
#   {
#     # Defaults to 127.0.0.1 if not set
#     'server' => '127.0.0.1',
#     # Defaults to 4730 if not set
#     'port' => '4730',
#     'tasks' => [
#       'TASK_1',
#       'TASK_2',
#     ],
#     'tags' => [
#       '<KEY_1>:<VALUE_1>',
#       '<KEY_2>:<VALUE_2>'
#     ],
#     'service' => '<SERVICE>',
#     # Defaults to 15 if not set
#     'min_collection_interval' => 60,
#     # Defaults to false if not set
#     'empty_default_hostname' => true,
#     'metric_patterns' => {
#       'include' => [
#         '<INCLUDE_REGEX>'
#       ],
#       'exclude' => [
#         '<EXCLUDE_REGEX>'
#       ]
#     }
#   }
# ]

datadog_monitor 'gearmand' do
  instances node['datadog']['gearmand']['instances']
  logs node['datadog']['gearmand']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
