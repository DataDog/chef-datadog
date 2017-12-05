include_recipe 'datadog::dd-agent'

# Monitor couchbase
#
# Assuming you have 2 instances on the same host
# you need to set up the following attributes.
# Each instance's metric will be tagged with "instance:server_url".
# to help you differentiate between instances.
#
# node['datadog']['couchbase']['instances'] = [
#   {
#     server: 'http://localhost:1234'
#   },
#   {
#     server: 'http://localhost:4567'
#   }
# ]

datadog_monitor 'couchbase' do
  instances node['datadog']['couchbase']['instances']
  logs node['datadog']['couchbase']['logs']
end
