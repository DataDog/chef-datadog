include_recipe 'datadog::dd-agent'

# Monitor fluentd
#
# node.override['datadog']['fluentd']['instances'] = [
#   {
#     'monitor_agent_url' => "http://example.com:24220/api/plugins.json",
#     'plugin_ids' => ["plg1", "plg2"],
#     'tags' => ["tag1", "tag2"]
#   }
# ]

datadog_monitor 'fluentd' do
  instances node['datadog']['fluentd']['instances']
  logs node['datadog']['fluentd']['logs']
end
