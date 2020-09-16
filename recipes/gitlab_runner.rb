include_recipe 'datadog::dd-agent'

# Monitor Gitlab Runner
#
# Here is the description of acceptable attributes:
# node.datadog.gitlab_runner = {
#   # init_config - required: false
#   "init_config" => {
#     # allowed_metrics - required: true  - array of string
#     "allowed_metrics" => [
#       "ci_docker_machines_provider_machine_creation_duration_seconds",
#       "ci_docker_machines_provider_machine_states",
#       "ci_runner_builds",
#       "ci_runner_errors",
#       "ci_ssh_docker_machines_provider_machine_creation_duration_seconds",
#       "ci_ssh_docker_machines_provider_machine_states",
#       "gitlab_runner_autoscaling_machine_creation_duration_seconds",
#       "gitlab_runner_autoscaling_machine_states",
#       "gitlab_runner_errors_total",
#       "gitlab_runner_jobs",
#       "gitlab_runner_version_info",
#       "go_gc_duration_seconds",
#       "go_goroutines",
#       "go_memstats_alloc_bytes",
#       "go_memstats_alloc_bytes_total",
#       "go_memstats_buck_hash_sys_bytes",
#       "go_memstats_frees_total",
#       "go_memstats_gc_sys_bytes",
#       "go_memstats_heap_alloc_bytes",
#       "go_memstats_heap_idle_bytes",
#       "go_memstats_heap_inuse_bytes",
#       "go_memstats_heap_objects",
#       "go_memstats_heap_released_bytes_total",
#       "go_memstats_heap_sys_bytes",
#       "go_memstats_last_gc_time_seconds",
#       "go_memstats_lookups_total",
#       "go_memstats_mallocs_total",
#       "go_memstats_mcache_inuse_bytes",
#       "go_memstats_mcache_sys_bytes",
#       "go_memstats_mspan_inuse_bytes",
#       "go_memstats_mspan_sys_bytes",
#       "go_memstats_next_gc_bytes",
#       "go_memstats_other_sys_bytes",
#       "go_memstats_stack_inuse_bytes",
#       "go_memstats_stack_sys_bytes",
#       "go_memstats_sys_bytes",
#       "process_cpu_seconds_total",
#       "process_max_fds",
#       "process_open_fds",
#       "process_resident_memory_bytes",
#       "process_start_time_seconds",
#       "process_virtual_memory_bytes",
#     ],
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
#       # gitlab_url - required: true  - string
#       "gitlab_url" => nil,
#       # prometheus_endpoint - required: true  - string
#       "prometheus_endpoint" => "http://<PROMETHEUS_ENDPOINT>:<PROMETHEUS_PORT>/metrics",
#       # prometheus_url - required: true  - string
#       "prometheus_url" => nil,
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
#   # logs - required: false
#   "logs" => nil,
# }

datadog_monitor 'gitlab_runner' do
  init_config node['datadog']['gitlab_runner']['init_config']
  instances node['datadog']['gitlab_runner']['instances']
  logs node['datadog']['gitlab_runner']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
