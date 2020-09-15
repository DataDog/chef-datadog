include_recipe 'datadog::dd-agent'

# Monitor ProxySQL
#
# Here is the description of acceptable attributes:
# node.datadog.proxysql = {
#   # init_config - required: false
#   "init_config" => {
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # host - required: true  - string
#       "host" => "<PROXYSQL_HOST>",
#       # port - required: true  - integer
#       "port" => nil,
#       # username - required: true  - string
#       "username" => "<PROXYSQL_ADMIN_USER>",
#       # password - required: true  - string
#       "password" => "<PROXYSQL_ADMIN_PASSWORD>",
#       # tls_verify - required: false  - boolean
#       "tls_verify" => false,
#       # tls_ca_cert - required: false  - string
#       "tls_ca_cert" => "<CA_CERT_PATH>",
#       # validate_hostname - required: false  - boolean
#       "validate_hostname" => true,
#       # connect_timeout - required: false  - integer
#       "connect_timeout" => 10,
#       # read_timeout - required: false  - integer
#       "read_timeout" => nil,
#       # additional_metrics - required: false  - array of string
#       "additional_metrics" => [
#         "command_counters_metrics",
#         "connection_pool_metrics",
#         "users_metrics",
#         "memory_metrics",
#         "query_rules_metrics",
#       ],
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

datadog_monitor 'proxysql' do
  init_config node['datadog']['proxysql']['init_config']
  instances node['datadog']['proxysql']['instances']
  logs node['datadog']['proxysql']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
