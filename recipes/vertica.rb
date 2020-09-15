include_recipe 'datadog::dd-agent'

# Monitor Vertica
#
# Here is the description of acceptable attributes:
# node.datadog.vertica = {
#   # init_config - required: false
#   "init_config" => {
#     # global_custom_queries - required: false  - array of object
#     "global_custom_queries" => [
#       {
#         "metric_prefix" => "vertica",
#         "query" => "<QUERY>",
#         "columns" => "<COLUMNS>",
#         "tags" => "<TAGS>",
#       },
#     ],
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # db - required: true  - string
#       "db" => "<DATABASE_NAME>",
#       # server - required: true  - string
#       "server" => "<SERVER>",
#       # port - required: true  - integer
#       "port" => 5433,
#       # username - required: true  - string
#       "username" => "<USERNAME>",
#       # password - required: false  - string
#       "password" => "<PASSWORD>",
#       # backup_servers - required: false  - array of object
#       "backup_servers" => [
#         {
#           "server" => "<SERVER_1>",
#           "port" => "<PORT_1>",
#         },
#         {
#           "server" => "<SERVER_2>",
#           "port" => "<PORT_2>",
#         },
#       ],
#       # connection_load_balance - required: false  - boolean
#       "connection_load_balance" => false,
#       # timeout - required: false  - integer
#       "timeout" => 10,
#       # tls_verify - required: false  - boolean
#       "tls_verify" => false,
#       # validate_hostname - required: false  - boolean
#       "validate_hostname" => true,
#       # cert - required: false  - string
#       "cert" => "<CERT_PATH>",
#       # private_key - required: false  - string
#       "private_key" => "<PRIVATE_KEY_PATH>",
#       # ca_cert - required: false  - string
#       "ca_cert" => "<CA_CERT_PATH>",
#       # tags - required: false  - array of string
#       "tags" => [
#         "<KEY_1>:<VALUE_1>",
#         "<KEY_2>:<VALUE_2>",
#       ],
#       # use_global_custom_queries - required: false  - string
#       "use_global_custom_queries" => "true",
#       # custom_queries - required: false  - array of object
#       "custom_queries" => [
#         {
#           "query" => "SELECT force_outer, table_name FROM v_catalog.tables",
#           "columns" => [
#             {
#               "name" => "table.force_outer",
#               "type" => "gauge",
#             },
#             {
#               "name" => "table_name",
#               "type" => "tag",
#             },
#           ],
#           "tags" => [
#             {
#               "test" => "vertica",
#             },
#           ],
#         },
#       ],
#       # client_lib_log_level - required: false  - string
#       "client_lib_log_level" => "<CLIENT_LIB_LOG_LEVEL>",
#       # logs - required: false
#       "logs" => nil,
#     },
#   ],
# }

datadog_monitor 'vertica' do
  init_config node['datadog']['vertica']['init_config']
  instances node['datadog']['vertica']['instances']
  logs node['datadog']['vertica']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
