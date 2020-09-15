include_recipe 'datadog::dd-agent'

# Monitor IBM MQ
#
# Here is the description of acceptable attributes:
# node.datadog.ibm_mq = {
#   # init_config - required: false
#   "init_config" => {
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # channel - required: true  - string
#       "channel" => "DEV.ADMIN.SVRCONN",
#       # queue_manager - required: true  - string
#       "queue_manager" => "datadog",
#       # host - required: false  - string
#       "host" => "localhost",
#       # port - required: false  - integer
#       "port" => 1414,
#       # connection_name - required: false  - string
#       "connection_name" => nil,
#       # username - required: false  - string
#       "username" => nil,
#       # password - required: false  - string
#       "password" => nil,
#       # queues - required: false  - array of string
#       "queues" => [
#         "<QUEUE_NAME>",
#       ],
#       # queue_patterns - required: false  - array of string
#       "queue_patterns" => [
#         "DEV.*",
#         "SYSTEM.*",
#       ],
#       # queue_regex - required: false  - array of string
#       "queue_regex" => [
#         "^DEV\\..*$",
#         "^SYSTEM\\..*$",
#       ],
#       # channels - required: false  - array of string
#       "channels" => [
#         "<CHANNEL_NAME>",
#       ],
#       # channel_status_mapping - required: false  - object
#       "channel_status_mapping" => {
#         "inactive" => "critical",
#         "binding" => "warning",
#         "starting" => "warning",
#         "running" => "ok",
#         "stopping" => "critical",
#         "retrying" => "warning",
#         "stopped" => "critical",
#         "requesting" => "warning",
#         "paused" => "warning",
#         "initializing" => "warning",
#       },
#       # auto_discover_queues - required: false  - boolean
#       "auto_discover_queues" => false,
#       # collect_statistics_metrics - required: false  - boolean
#       "collect_statistics_metrics" => false,
#       # mqcd_version - required: false  - number
#       "mqcd_version" => 6,
#       # ssl_auth - required: false  - boolean
#       "ssl_auth" => false,
#       # ssl_cipher_spec - required: false  - string
#       "ssl_cipher_spec" => "TLS_RSA_WITH_AES_256_CBC_SHA",
#       # ssl_key_repository_location - required: false  - string
#       "ssl_key_repository_location" => "/var/mqm/ssl-db/client/KeyringClient",
#       # ssl_certificate_label - required: false  - string
#       "ssl_certificate_label" => nil,
#       # queue_tag_re - required: false  - object
#       "queue_tag_re" => {
#         "SYSTEM.*" => "queue_type:system",
#         "DEV.*" => "role:dev,queue_type:default",
#       },
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

datadog_monitor 'ibm_mq' do
  init_config node['datadog']['ibm_mq']['init_config']
  instances node['datadog']['ibm_mq']['instances']
  logs node['datadog']['ibm_mq']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
