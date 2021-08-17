include_recipe '::dd-agent'

# Monitor Varnish
#
# You'll need to set up the following attributes:
# node.datadog.varnish.instances = [
#
#   # Path to varnishstat (required)
#   {
#     :varnishstat => "/opt/local/bin/varnishstat"
#   },
#
#   # Tags to apply to all varnish metrics (optional)
#   {
#     :tags => ["test", "cache"]
#   },
#
#   # Varnish instance name, passed to varnishstat -n (optional)
#   {
#     :name => "myvarnish0"
#   }
# ]

datadog_monitor 'varnish' do
  instances node['datadog']['varnish']['instances']
  logs node['datadog']['varnish']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
