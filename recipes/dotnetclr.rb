include_recipe 'datadog::dd-agent'

# Monitor .NET CLR
#
# Here is the description of acceptable attributes:
# node.datadog.dotnetclr = {
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

datadog_monitor 'dotnetclr' do
  init_config node['datadog']['dotnetclr']['init_config']
  instances node['datadog']['dotnetclr']['instances']
  logs node['datadog']['dotnetclr']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
