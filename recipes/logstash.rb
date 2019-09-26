include_recipe 'datadog::dd-agent'

# Monitor logstash
#
# Assuming you have a logstash instance on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['logstash']['instances'] = [
#   {
#     'url'        => 'http://localhost:9600',
#     # All the others are optional
#     'ssl_verify' => false,
#     'ssl_cert'   => '/path/to/cert.pem',
#     'ssl_key'    => '/path/to/cert.key',
#     'tags'       => [node.chef_environment]
#   }
# ]

datadog_monitor 'logstash' do
  instances node['datadog']['logstash']['instances']
end
