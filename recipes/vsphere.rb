include_recipe 'datadog::dd-agent'

# Monitor vSphere
#
# Here is the description of acceptable attributes:
# node.datadog.vsphere = {
#   # init_config - required: false
#   "init_config" => {
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # host - required: true  - string
#       "host" => "<HOSTNAME>",
#       # username - required: true  - string
#       "username" => "<USERNAME>",
#       # password - required: true  - string
#       "password" => "<PASSWORD>",
#       # use_legacy_check_version - required: true  - boolean
#       "use_legacy_check_version" => false,
#       # collection_level - required: false  - integer
#       "collection_level" => 1,
#       # collection_type - required: false  - string
#       "collection_type" => "realtime",
#       # collect_events - required: false  - boolean
#       "collect_events" => true,
#       # use_collect_events_fallback - required: false  - boolean
#       "use_collect_events_fallback" => false,
#       # collect_events_only - required: false  - boolean
#       "collect_events_only" => false,
#       # ssl_verify - required: false  - boolean
#       "ssl_verify" => true,
#       # ssl_capath - required: false  - string
#       "ssl_capath" => "<DIRECTORY_PATH>",
#       # tls_ignore_warning - required: false  - boolean
#       "tls_ignore_warning" => false,
#       # resource_filters - required: false  - array of object
#       "resource_filters" => [
#         {
#           "resource" => "vm",
#           "property" => "name",
#           "patterns" => [
#             "<VM_REGEX_1>",
#             "<VM_REGEX_2>",
#           ],
#         },
#         {
#           "resource" => "vm",
#           "property" => "hostname",
#           "patterns" => [
#             "<HOSTNAME_REGEX>",
#           ],
#         },
#         {
#           "resource" => "vm",
#           "property" => "tag",
#           "type" => "blacklist",
#           "patterns" => [
#             "^env:staging$",
#           ],
#         },
#         {
#           "resource" => "vm",
#           "property" => "tag",
#           "type" => "whitelist",
#           "patterns" => [
#             "^env:.*$",
#           ],
#         },
#         {
#           "resource" => "vm",
#           "property" => "guest_hostname",
#           "patterns" => [
#             "<GUEST_HOSTNAME_REGEX>",
#           ],
#         },
#         {
#           "resource" => "host",
#           "property" => "inventory_path",
#           "patterns" => [
#             "<INVENTORY_PATH_REGEX>",
#           ],
#         },
#       ],
#       # metric_filters - required: false  - object
#       "metric_filters" => {
#         "vm" => [
#           "<VM_REGEX>",
#         ],
#         "host" => [
#           "<HOST_REGEX>",
#         ],
#         "datastore" => [
#           "<DATASTORE_REGEX>",
#         ],
#         "datacenter" => [
#           "<DATACENTER_REGEX>",
#         ],
#         "cluster" => [
#           "<CLUSTER_REGEX>",
#         ],
#       },
#       # collect_per_instance_filters - required: false  - object
#       "collect_per_instance_filters" => {
#         "vm" => [
#           "<VM_REGEX>",
#         ],
#         "host" => [
#           "<HOST_REGEX>",
#         ],
#         "datastore" => [
#           "<DATASTORE_REGEX>",
#         ],
#         "cluster" => [
#           "<CLUSTER_REGEX>",
#         ],
#       },
#       # collect_tags - required: false  - boolean
#       "collect_tags" => false,
#       # tags_prefix - required: false  - string
#       "tags_prefix" => "",
#       # collect_attributes - required: false  - boolean
#       "collect_attributes" => false,
#       # attributes_prefix - required: false  - string
#       "attributes_prefix" => "",
#       # use_guest_hostname - required: false  - boolean
#       "use_guest_hostname" => false,
#       # threads_count - required: false  - integer
#       "threads_count" => 4,
#       # excluded_host_tags - required: false  - array of string
#       "excluded_host_tags" => [
#         "<HOST_TAG>",
#       ],
#       # metrics_per_query - required: false  - integer
#       "metrics_per_query" => 50,
#       # max_historical_metrics - required: false  - integer
#       "max_historical_metrics" => 256,
#       # batch_tags_collector_size - required: false  - integer
#       "batch_tags_collector_size" => 200,
#       # batch_property_collector_size - required: false  - integer
#       "batch_property_collector_size" => 500,
#       # refresh_infrastructure_cache_interval - required: false  - integer
#       "refresh_infrastructure_cache_interval" => 300,
#       # refresh_metrics_metadata_cache_interval - required: false  - integer
#       "refresh_metrics_metadata_cache_interval" => 1800,
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

datadog_monitor 'vsphere' do
  init_config node['datadog']['vsphere']['init_config']
  instances node['datadog']['vsphere']['instances']
  logs node['datadog']['vsphere']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
