include_recipe 'datadog::dd-agent'

# Monitor Btrfs
#
# Here is the description of acceptable attributes:
# node.datadog.btrfs = {
#   # init_config - required: false
#   "init_config" => {
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # excluded_devices - required: false  - array of string
#       "excluded_devices" => [
#         "<DEVICE_1>",
#         "<DEVICE_2>",
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

datadog_monitor 'btrfs' do
  init_config node['datadog']['btrfs']['init_config']
  instances node['datadog']['btrfs']['instances']
  logs node['datadog']['btrfs']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
