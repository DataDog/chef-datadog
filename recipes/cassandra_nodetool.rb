include_recipe 'datadog::dd-agent'

# Monitor Cassandra Nodetool
#
# Here is the description of acceptable attributes:
# node.datadog.cassandra_nodetool = {
#   # init_config - required: false
#   "init_config" => {
#     # nodetool - required: true  - string
#     "nodetool" => "nodetool",
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # keyspaces - required: true  - array of string
#       "keyspaces" => nil,
#       # host - required: false  - string
#       "host" => "localhost",
#       # port - required: false  - integer
#       "port" => 7199,
#       # username - required: false  - string
#       "username" => nil,
#       # password - required: false  - string
#       "password" => nil,
#       # ssl - required: false  - boolean
#       "ssl" => false,
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

datadog_monitor 'cassandra_nodetool' do
  init_config node['datadog']['cassandra_nodetool']['init_config']
  instances node['datadog']['cassandra_nodetool']['instances']
  logs node['datadog']['cassandra_nodetool']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
