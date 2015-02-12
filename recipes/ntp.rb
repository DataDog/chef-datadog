include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @see https://github.com/DataDog/dd-agent/blob/master/conf.d/ntp.yaml.example
# @example
#   node.override['datadog']['ntp']['instances'] = [
#     {
#       'offset_threshold' => '600',
#       'host' => 'pool.ntp.org',
#       'port' => 'ntp',
#       'version' => '3',
#       'timeout' => '5'
#     }
#   ]
datadog_monitor 'ntp' do
  instances node['datadog']['ntp']['instances']
end
