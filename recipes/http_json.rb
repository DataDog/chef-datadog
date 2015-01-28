include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @example
#   node.override['datadog']['http_json']['instances'] = [
#     {
#       'url' => 'http://my.server/health',
#       'timeout' => '15',
#       'prefix' => 'myapp.',
#       'tags' => [
#          'myApp',
#          'serviceName'
#       ],
#       'metrics' => {
#          'someCounterMetric' => 'counter',
#          'someGaugeMetric' => 'gauge'
#       }
#     }
#   ]
datadog_monitor 'http_json' do
  instances node['datadog']['http_json']['instances']
end
