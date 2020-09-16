include_recipe 'datadog::dd-agent'

# Monitor nginx-ingress-controller
#
# Here is the description of acceptable attributes:
# node.datadog.nginx_ingress_controller = {
#   # init_config - required: false
#   "init_config" => {
#     # proxy - required: false  - object
#     "proxy" => {
#       "http" => "http://<PROXY_SERVER_FOR_HTTP>:<PORT>",
#       "https" => "https://<PROXY_SERVER_FOR_HTTPS>:<PORT>",
#       "no_proxy" => [
#         "<HOSTNAME_1>",
#         "<HOSTNAME_2>",
#       ],
#     },
#     # skip_proxy - required: false  - boolean
#     "skip_proxy" => false,
#     # timeout - required: false  - number
#     "timeout" => 10,
#     # service - required: false  - string
#     "service" => nil,
#   },
#   # instances - required: false
#   "instances" => [
#     {
#       # collect_nginx_histograms - required: false  - boolean
#       "collect_nginx_histograms" => false,
#       # prometheus_url - required: true  - string
#       "prometheus_url" => "http://localhost:10254/metrics",
#       # namespace - required: true  - string
#       "namespace" => "service",
#       # metrics - required: true  - array of string
#       "metrics" => [
#         "processor:cpu",
#         "memory:mem",
#         "io",
#       ],
#       # prometheus_metrics_prefix - required: false  - string
#       "prometheus_metrics_prefix" => "<PREFIX>_",
#       # health_service_check - required: false  - boolean
#       "health_service_check" => true,
#       # label_to_hostname - required: false  - string
#       "label_to_hostname" => "<LABEL>",
#       # label_joins - required: false  - object
#       "label_joins" => {
#         "target_metric" => {
#           "label_to_match" => "<MATCHED_LABEL>",
#           "labels_to_get" => [
#             "<EXTRA_LABEL_1>",
#             "<EXTRA_LABEL_2>",
#           ],
#         },
#       },
#       # labels_mapper - required: false  - object
#       "labels_mapper" => {
#         "flavor" => "origin",
#       },
#       # type_overrides - required: false  - object
#       "type_overrides" => {
#         "<METRIC_NAME>" => "<METRIC_TYPE>",
#       },
#       # send_histograms_buckets - required: false  - boolean
#       "send_histograms_buckets" => true,
#       # send_distribution_buckets - required: false  - boolean
#       "send_distribution_buckets" => false,
#       # send_monotonic_counter - required: false  - boolean
#       "send_monotonic_counter" => true,
#       # send_monotonic_with_gauge - required: false  - boolean
#       "send_monotonic_with_gauge" => false,
#       # send_distribution_counts_as_monotonic - required: false  - boolean
#       "send_distribution_counts_as_monotonic" => false,
#       # send_distribution_sums_as_monotonic - required: false  - boolean
#       "send_distribution_sums_as_monotonic" => false,
#       # exclude_labels - required: false  - array of string
#       "exclude_labels" => [
#         "timestamp",
#       ],
#       # bearer_token_auth - required: false  - boolean
#       "bearer_token_auth" => false,
#       # bearer_token_path - required: false  - string
#       "bearer_token_path" => "<TOKEN_PATH>",
#       # ignore_metrics - required: false  - array of string
#       "ignore_metrics" => [
#         "<IGNORED_METRIC_NAME>",
#         "<PREFIX_*>",
#         "<*_SUFFIX>",
#         "<PREFIX_*_SUFFIX>",
#         "<*_SUBSTRING_*>",
#       ],
#       # proxy - required: false  - object
#       "proxy" => {
#         "http" => "http://<PROXY_SERVER_FOR_HTTP>:<PORT>",
#         "https" => "https://<PROXY_SERVER_FOR_HTTPS>:<PORT>",
#         "no_proxy" => [
#           "<HOSTNAME_1>",
#           "<HOSTNAME_2>",
#         ],
#       },
#       # skip_proxy - required: false  - boolean
#       "skip_proxy" => false,
#       # auth_type - required: false  - string
#       "auth_type" => "basic",
#       # use_legacy_auth_encoding - required: false  - boolean
#       "use_legacy_auth_encoding" => true,
#       # username - required: false  - string
#       "username" => nil,
#       # password - required: false  - string
#       "password" => nil,
#       # ntlm_domain - required: false  - string
#       "ntlm_domain" => "<NTLM_DOMAIN>\\<USERNAME>",
#       # kerberos_auth - required: false  - string
#       "kerberos_auth" => "disabled",
#       # kerberos_cache - required: false  - string
#       "kerberos_cache" => nil,
#       # kerberos_delegate - required: false  - boolean
#       "kerberos_delegate" => false,
#       # kerberos_force_initiate - required: false  - boolean
#       "kerberos_force_initiate" => false,
#       # kerberos_hostname - required: false  - string
#       "kerberos_hostname" => nil,
#       # kerberos_principal - required: false  - string
#       "kerberos_principal" => nil,
#       # kerberos_keytab - required: false  - string
#       "kerberos_keytab" => "<KEYTAB_FILE_PATH>",
#       # aws_region - required: false  - string
#       "aws_region" => nil,
#       # aws_host - required: false  - string
#       "aws_host" => nil,
#       # aws_service - required: false  - string
#       "aws_service" => nil,
#       # tls_verify - required: false  - boolean
#       "tls_verify" => true,
#       # tls_use_host_header - required: false  - boolean
#       "tls_use_host_header" => false,
#       # tls_ignore_warning - required: false  - boolean
#       "tls_ignore_warning" => false,
#       # tls_cert - required: false  - string
#       "tls_cert" => "<CERT_PATH>",
#       # tls_private_key - required: false  - string
#       "tls_private_key" => "<PRIVATE_KEY_PATH>",
#       # tls_ca_cert - required: false  - string
#       "tls_ca_cert" => "<CA_CERT_PATH>",
#       # headers - required: false  - object
#       "headers" => {
#         "Host" => "<ALTERNATIVE_HOSTNAME>",
#         "X-Auth-Token" => "<AUTH_TOKEN>",
#       },
#       # extra_headers - required: false  - object
#       "extra_headers" => {
#         "Host" => "<ALTERNATIVE_HOSTNAME>",
#         "X-Auth-Token" => "<AUTH_TOKEN>",
#       },
#       # timeout - required: false  - number
#       "timeout" => 10,
#       # connect_timeout - required: false  - number
#       "connect_timeout" => nil,
#       # read_timeout - required: false  - number
#       "read_timeout" => nil,
#       # log_requests - required: false  - boolean
#       "log_requests" => false,
#       # persist_connections - required: false  - boolean
#       "persist_connections" => false,
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

datadog_monitor 'nginx_ingress_controller' do
  init_config node['datadog']['nginx_ingress_controller']['init_config']
  instances node['datadog']['nginx_ingress_controller']['instances']
  logs node['datadog']['nginx_ingress_controller']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
