include_recipe 'datadog::dd-agent'

# Monitor Ceph
#
# Here is the description of acceptable attributes:
# node.datadog.ceph = {
#   # init_config - required: false
#   "init_config" => {
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # ceph_cmd - required: false  - string
#       "ceph_cmd" => "/usr/bin/ceph",
#       # ceph_cluster - required: false  - string
#       "ceph_cluster" => "ceph",
#       # use_sudo - required: false  - boolean
#       "use_sudo" => false,
#       # collect_service_check_for - required: false  - array of string
#       "collect_service_check_for" => [
#         "OSD_DOWN",
#         "OSD_ORPHAN",
#         "OSD_FULL",
#         "OSD_NEARFULL",
#         "POOL_FULL",
#         "POOL_NEAR_FULL",
#         "PG_AVAILABILITY",
#         "PG_DEGRADED",
#         "PG_DEGRADED_FULL",
#         "PG_DAMAGED",
#         "PG_NOT_SCRUBBED",
#         "PG_NOT_DEEP_SCRUBBED",
#         "CACHE_POOL_NEAR_FULL",
#         "TOO_FEW_PGS",
#         "TOO_MANY_PGS",
#         "OBJECT_UNFOUND",
#         "REQUEST_SLOW",
#         "REQUEST_STUCK",
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

datadog_monitor 'ceph' do
  init_config node['datadog']['ceph']['init_config']
  instances node['datadog']['ceph']['instances']
  logs node['datadog']['ceph']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
