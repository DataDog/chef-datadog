include_recipe 'datadog::dd-agent'

# Monitor Go metrics exported via expvar
#  node['datadog']['go_expvar']['instances'] = [
#   {
#     'expvar_url' => 'http://localhost:8080/debug/vars',
#     'tags' => [
#        'application:my_go_app'
#      ],
#     'metrics' => [
#       {
#         'path' => 'test_metrics_name_1', 'alias' => 'go_expvar.test_metrics_name_1', 'type' => 'gauge'
#       },
#       {
#         'path' => 'test_metrics_name_2', 'alias' => 'go_expvar.test_metrics_name_2', 'type' => 'gauge', 'tags' => ['tag1', 'tag2']
#       }
#     ]
#   }
#  ]

datadog_monitor 'go_expvar' do
  init_config node['datadog']['go_expvar']['init_config']
  instances node['datadog']['go_expvar']['instances']
  logs node['datadog']['go_expvar']['logs']
end
