include_recipe 'datadog::dd-agent'

# Monitor Ignite
#
# Here is the description of acceptable attributes:
# node.datadog.ignite = {
#   # init_config - required: false
#   "init_config" => {
#     # is_jmx - required: true  - boolean
#     "is_jmx" => true,
#     # collect_default_metrics - required: true  - boolean
#     "collect_default_metrics" => true,
#     # new_gc_metrics - required: false  - boolean
#     "new_gc_metrics" => false,
#     # service_check_prefix - required: false  - string
#     "service_check_prefix" => nil,
#     # conf - required: false  - array of object
#     "conf" => [
#       {
#         "include" => {
#           "bean" => "<BEAN_NAME>",
#           "attribute" => {
#             "MyAttribute" => {
#               "alias" => "my.metric.name",
#               "metric_type" => "gauge",
#             },
#           },
#         },
#       },
#     ],
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # host - required: true  - string
#       "host" => nil,
#       # port - required: true  - integer
#       "port" => 49112,
#       # jmx_url - required: false  - string
#       "jmx_url" => nil,
#       # user - required: false  - string
#       "user" => nil,
#       # password - required: false  - string
#       "password" => nil,
#       # process_name_regex - required: false  - string
#       "process_name_regex" => nil,
#       # tools_jar_path - required: false  - string
#       "tools_jar_path" => nil,
#       # name - required: false  - string
#       "name" => nil,
#       # java_bin_path - required: false  - string
#       "java_bin_path" => nil,
#       # java_options - required: false  - string
#       "java_options" => nil,
#       # trust_store_path - required: false  - string
#       "trust_store_path" => nil,
#       # trust_store_password - required: false  - string
#       "trust_store_password" => nil,
#       # key_store_path - required: false  - string
#       "key_store_path" => nil,
#       # key_store_password - required: false  - string
#       "key_store_password" => nil,
#       # rmi_registry_ssl - required: false  - boolean
#       "rmi_registry_ssl" => false,
#       # rmi_connection_timeout - required: false  - number
#       "rmi_connection_timeout" => 20000,
#       # rmi_client_timeout - required: false  - number
#       "rmi_client_timeout" => 15000,
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

datadog_monitor 'ignite' do
  init_config node['datadog']['ignite']['init_config']
  instances node['datadog']['ignite']['instances']
  logs node['datadog']['ignite']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
