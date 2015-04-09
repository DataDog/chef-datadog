include_recipe 'datadog::dd-agent'

# Monitor docker
#
# Assuming you have 2 instances "prod" and "test", you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['docker']['instances'] = [
#   {
#     'socket' => "unix://var/run/docker.sock",
#     'tags' => ["prod"]
#   },
#   {
#     'socket' => "tcp://localhost:4444",
#     'name' => ["test"]
#   }
# ]

datadog_monitor 'docker' do
  instances node['datadog']['docker']['instances']
end
