include_recipe 'datadog::dd-agent'

# Monitor ClickHouse
#
# Here is the description of acceptable attributes:
# node.datadog.clickhouse = {
#   # init_config - required: false
#   "init_config" => {
#     # global_custom_queries - required: false  - array of object
#     "global_custom_queries" => [
#       {
#         "metric_prefix" => "clickhouse",
#         "query" => "<QUERY>",
#         "columns" => "<COLUMNS>",
#         "tags" => "<TAGS>",
#       },
#     ],
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # server - required: true  - string
#       "server" => nil,
#       # port - required: false  - integer
#       "port" => 9000,
#       # user - required: false  - string
#       "user" => "default",
#       # password - required: false  - string
#       "password" => nil,
#       # db - required: false  - string
#       "db" => nil,
#       # connect_timeout - required: false  - integer
#       "connect_timeout" => 10,
#       # read_timeout - required: false  - integer
#       "read_timeout" => 10,
#       # compression - required: false  - string
#       "compression" => nil,
#       # tls_verify - required: false  - boolean
#       "tls_verify" => false,
#       # use_global_custom_queries - required: false  - string
#       "use_global_custom_queries" => "true",
#       # custom_queries - required: false  - array of object
#       "custom_queries" => [
#         {
#           "query" => "SELECT foo, COUNT(*) FROM table.events GROUP BY foo",
#           "columns" => [
#             {
#               "name" => "foo",
#               "type" => "tag",
#             },
#             {
#               "name" => "event.total",
#               "type" => "gauge",
#             },
#           ],
#           "tags" => [
#             "test:clickhouse",
#           ],
#         },
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
#   # logs - required: false
#   "logs" => nil,
# }

datadog_monitor 'clickhouse' do
  init_config node['datadog']['clickhouse']['init_config']
  instances node['datadog']['clickhouse']['instances']
  logs node['datadog']['clickhouse']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
