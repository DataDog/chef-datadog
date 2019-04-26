include_recipe 'datadog::dd-agent'

# Monitor consul
#
# Assuming you have a consul instance on a given server, you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# Note that the Agent only supports monitoring one Consul instance
#
# A few explanatory words:
#  - `catalog_checks`: Whether to perform checks against the Consul service Catalog
#  - `new_leader_checks`: Whether to enable new leader checks from this agent
#     Note: if this is set on multiple agents in the same cluster
#     you will receive one event per leader change per agent
#  - `service_whitelist`: Services to restrict catalog querying to
#    The default settings query up to 50 services. So if you have more than
#    this many in your Consul service catalog, you will want to fill in the
#    whitelist
#
# node['datadog']['consul']['instances'] = [
#   {
#     'url'               => 'http://localhost:8500',
#     'new_leader_checks' => false,
#     'catalog_checks'    => false,
#     'service_whitelist' => [],
#     'tags'              => [node.chef_environment]
#   }
# ]

datadog_monitor 'consul' do
  instances node['datadog']['consul']['instances']
  logs node['datadog']['consul']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
