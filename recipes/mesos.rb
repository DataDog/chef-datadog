include_recipe 'datadog::dd-agent'

# Monitor mesos
#
# Assuming you have 2 instances "prod" and "test", you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['mesos']['instances'] = [
#   {
#     'url' => "http://localhost:5050",
#     'tags' => ["prod"]
#   },
#   {
#     'url' => "tcp://localhost:4444",
#     'name' => ["test"]
#   }
# ]

datadog_monitor 'mesos' do
  instances node['datadog']['mesos']['instances']
end
