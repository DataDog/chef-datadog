include_recipe 'datadog::dd-agent'

# Monitor http
# @see http://docs.datadoghq.com/guides/network_checks/
#
# Assuming you have a web server you want to check
# via http you could set up the following attributes
# node.datadog.http_check.instances = [
#     {
#       'name' => 'MyHTTPcheck',
#       'url' => 'http://my.server/some/service',
#       'timeout' => '15',
#       'content_match' => 'string to match',
#       'include_content' => true,
#       'collect_response_time' => true,
#       'skip_event' => true,
#       'tags' => [
#        'myApp',
#        'serviceName'
#       ]
#     }
# ]

datadog_monitor 'http_check' do
  instances node['datadog']['http_check']['instances']
end
