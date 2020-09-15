include_recipe 'datadog::dd-agent'

# Monitor ASP.NET
#
# Here is the description of acceptable attributes:
# node.datadog.aspdotnet = {
#   # init_config - required: false
#   "init_config" => {
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # host - required: true  - string
#       "host" => ".",
#       # port - required: true  - integer
#       "port" => 26379,
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

datadog_monitor 'aspdotnet' do
  init_config node['datadog']['aspdotnet']['init_config']
  instances node['datadog']['aspdotnet']['instances']
  logs node['datadog']['aspdotnet']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
