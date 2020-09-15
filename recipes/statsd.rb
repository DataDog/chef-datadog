include_recipe 'datadog::dd-agent'

# Monitor StatsD
#
# Here is the description of acceptable attributes:
# node.datadog.statsd = {
#   # init_config - required: false
#   "init_config" => {
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # host - required: true  - string
#       "host" => "localhost",
#       # port - required: true  - integer
#       "port" => 8126,
#       # timeout - required: false  - integer
#       "timeout" => 10,
#       # tags - required: false  - array of string
#       "tags" => [
#         "<KEY_1>:<VALUE_1>",
#         "<KEY_2>:<VALUE_2>",
#       ],
#       # service - required: false  - string
#       "service" => nil,
#       # min_collection_interval - required: false  - number
#       "min_collection_interval" => 15,
#       # empty_default_hostname - required: false  - boolean
#       "empty_default_hostname" => false,
#     },
#   ],
# }

datadog_monitor 'statsd' do
  init_config node['datadog']['statsd']['init_config']
  instances node['datadog']['statsd']['instances']
  logs node['datadog']['statsd']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
