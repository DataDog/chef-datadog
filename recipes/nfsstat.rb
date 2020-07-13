include_recipe 'datadog::dd-agent'

# Monitor Nfsstat
#
# Here is the description of acceptable attributes:
# node.datadog.nfsstat = {
#   # init_config - required: false
#   "init_config" => {
#     # nfsiostat_path - required: false  - string
#     "nfsiostat_path" => "/usr/local/sbin/nfsiostat",
#     # autofs_enabled - required: false  - boolean
#     "autofs_enabled" => false,
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
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

datadog_monitor 'nfsstat' do
  instances node['datadog']['nfsstat']['instances']
  logs node['datadog']['nfsstat']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
