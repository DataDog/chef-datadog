include_recipe 'datadog::dd-agent'

# Monitor PDH
#
# Here is the description of acceptable attributes:
# node.datadog.pdh_check = {
#   # init_config - required: false
#   "init_config" => {
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # admin_share - required: false  - string
#       "admin_share" => "c$",
#       # countersetname - required: true  - string
#       "countersetname" => "<COUNTER_SET_NAME>",
#       # metrics - required: true  - array of array of string
#       "metrics" => [
#         "<COUNTER_NAME>",
#         "<METRIC_NAME>",
#         "<METRIC_TYPE>",
#       ],
#       # host - required: false  - string
#       "host" => ".",
#       # username - required: false  - string
#       "username" => nil,
#       # password - required: false  - string
#       "password" => nil,
#       # additional_metrics - required: false  - array of array of string
#       "additional_metrics" => [
#         "NTDS",
#         "none",
#         "DS % Writes from LDAP",
#         "active_directory.ds.writes_from_ldap",
#         "gauge",
#       ],
#       # counter_data_types - required: false  - array of string
#       "counter_data_types" => [
#         "<METRIC_NAME>",
#         "<DATA_TYPE>",
#         "active_directory.dra.inbound.bytes.total",
#         "int",
#         "active_directory.ldap.bind_time",
#         "float",
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

datadog_monitor 'pdh_check' do
  init_config node['datadog']['pdh_check']['init_config']
  instances node['datadog']['pdh_check']['instances']
  logs node['datadog']['pdh_check']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
