include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @note NTP check is enabled by default since datadog-agent 5.3.0.
# @see https://github.com/DataDog/integrations-core/blob/master/ntp/conf.yaml.default
# @example
#   node.override['datadog']['ntp']['instances'] = [
#     {
#       'offset_threshold' => '60',
#       'host' => 'pool.ntp.org',
#       'port' => 'ntp',
#       'version' => '3',
#       'timeout' => '5'
#     }
#   ]
datadog_monitor 'ntp' do
  instances node['datadog']['ntp']['instances']
  logs node['datadog']['ntp']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
