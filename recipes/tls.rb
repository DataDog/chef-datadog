include_recipe 'datadog::dd-agent'

# Monitor TLS
#
# Here is the description of acceptable attributes:
# node.datadog.tls = {
#   # init_config - required: false
#   "init_config" => {
#     # allowed_versions - required: false  - array of string
#     "allowed_versions" => [
#       "TLSv1.2",
#       "TLSv1.3",
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
#       "port" => 443,
#       # transport - required: false  - string
#       "transport" => "TCP",
#       # local_cert_path - required: false  - string
#       "local_cert_path" => nil,
#       # server_hostname - required: false  - string
#       "server_hostname" => nil,
#       # validate_hostname - required: false  - boolean
#       "validate_hostname" => true,
#       # validate_cert - required: false  - boolean
#       "validate_cert" => true,
#       # allowed_versions - required: false  - array of string
#       "allowed_versions" => [
#         "TLSv1.2",
#         "TLSv1.3",
#       ],
#       # days_warning - required: false  - number
#       "days_warning" => 14.0,
#       # days_critical - required: false  - number
#       "days_critical" => 7.0,
#       # seconds_warning - required: false  - integer
#       "seconds_warning" => nil,
#       # seconds_critical - required: false  - integer
#       "seconds_critical" => nil,
#       # cert - required: false  - string
#       "cert" => "<CERT_PATH>",
#       # private_key - required: false  - string
#       "private_key" => "<PRIVATE_KEY_PATH>",
#       # ca_cert - required: false  - string
#       "ca_cert" => "<CA_CERT_PATH>",
#       # timeout - required: false  - integer
#       "timeout" => 10,
#       # name - required: false  - string
#       "name" => nil,
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

datadog_monitor 'tls' do
  init_config node['datadog']['tls']['init_config']
  instances node['datadog']['tls']['instances']
  logs node['datadog']['tls']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
