include_recipe 'datadog::dd-agent'

# Monitor http
#
# Assuming you have 2 web servers you want to check
# via http you need to set up the following attributes
# node.datadog.http_check.instances = [
#                                     {
#                                       :name => "url1",
#                                       :url => "http://localhost/foo"
#                                     },
#                                     {
#                                       :name => "url2"
#                                       :url => "http://localhost:8080/bar"
#                                     }
#                                    ]

datadog_monitor 'http_check' do
  instances node['datadog']['http_check']['instances']
  init_config node['datadog']['http_check']['init_config'] if node['datadog']['http_check'].include?('init_config')
end
