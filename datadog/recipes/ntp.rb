include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @note NTP check is enabled by default since datadog-agent 5.3.0.
# @see https://github.com/DataDog/dd-agent/blob/master/conf.d/ntp.yaml.default
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
end
