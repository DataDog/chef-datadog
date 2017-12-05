include_recipe 'datadog::dd-agent'

# Monitor dns
#
# Create one attribute entry for each combination of hostname that
# you want to monitor + DNS server that you want to monitor it on.
#
# node['datadog']['dns_check']['instances'] = [
#   {
#     'hostname' => 'foo.example.com',
#     'nameserver' => 'prod-ns.example.com',
#     'timeout' => 1
#   },
#   {
#     'hostname' => 'baz.example.com',
#     'nameserver' => 'prod-ns.example.com',
#     'timeout' => 1
#   },
#   {
#     'hostname' => 'foo.example.com',
#     'nameserver' => 'test-ns.example.com',
#     'timeout' => 3
#   },
#   {
#     'hostname' => 'quux.example.com',
#     'nameserver' => 'test-ns.example.com',
#     'timeout' => 3
#   },
# ]

datadog_monitor 'dns_check' do
  instances node['datadog']['dns_check']['instances']
  logs node['datadog']['dns_check']['logs']
end
