include_recipe 'datadog::dd-agent'

# Monitor RethinkDB
#
# Here is the description of acceptable attributes:
# node.datadog.rethinkdb = {
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
#       "port" => 28015,
#       # username - required: false  - string
#       "username" => nil,
#       # password - required: false  - string
#       "password" => nil,
#       # tls_ca_cert - required: false  - string
#       "tls_ca_cert" => nil,
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
#   # logs - required: false
#   "logs" => nil,
# }

datadog_monitor 'rethinkdb' do
  init_config node['datadog']['rethinkdb']['init_config']
  instances node['datadog']['rethinkdb']['instances']
  logs node['datadog']['rethinkdb']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
