include_recipe 'datadog::dd-agent'

# Monitor the Windows Event Log
# @see https://github.com/DataDog/integrations-core/blob/master/win32_event_log/conf.yaml.example for details
#
# @example
#   node['datadog']['win32_event_log']['init_config'] = {
#     'tag_event_id'      => false                    # optional, defaults to false
#   }
#   node['datadog']['win32_event_log']['instances'] = [
#     {
#       'log_file'          => ['Application'],
#       'source_name'       => ['MSSQLSERVER'],
#       'type'              => ['Warning', 'Error'],
#       'message_filters'   => ['%error%'],
#       'tags'              => ['sqlserver']
#      }
#   ]

datadog_monitor 'win32_event_log' do
  init_config node['datadog']['win32_event_log']['init_config']
  instances node['datadog']['win32_event_log']['instances']
  logs node['datadog']['win32_event_log']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
