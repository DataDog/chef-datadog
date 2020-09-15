include_recipe 'datadog::dd-agent'

# Monitor Gitlab
#
# Here is the description of acceptable attributes:
# node.datadog.gitlab = {
#   # instances - required: false
#   "instances" => [
#     {
#       # gitlab_url - required: true  - string
#       "gitlab_url" => nil,
#       # api_token - required: false  - string
#       "api_token" => nil,
#       # prometheus_url - required: true  - string
#       "prometheus_url" => "http://<GITLAB_URL>/-/metrics",
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
#       "send_distribution_counts_as_monotonic" => true,
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
#     # allowed_metrics - required: false  - array of string
#     "allowed_metrics" => [
#       "go_gc_duration_seconds",
#       "go_gc_duration_seconds_sum",
#       "go_gc_duration_seconds_count",
#       "go_goroutines",
#       "go_memstats_alloc_bytes",
#       "go_memstats_alloc_bytes_total",
#       "go_memstats_buck_hash_sys_bytes",
#       "go_memstats_frees_total",
#       "go_memstats_gc_cpu_fraction",
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
#       "go_memstats_stack_inuse_bytes",
#       "go_memstats_stack_sys_bytes",
#       "go_memstats_sys_bytes",
#       "go_threads",
#       "http_request_duration_microseconds",
#       "http_request_size_bytes",
#       "http_requests_total",
#       "http_response_size_bytes",
#       "process_cpu_seconds_total",
#       "process_max_fds",
#       "process_open_fds",
#       "process_resident_memory_bytes",
#       "process_start_time_seconds",
#       "process_virtual_memory_bytes",
#       "prometheus_build_info",
#       "prometheus_config_last_reload_success_timestamp_seconds",
#       "prometheus_config_last_reload_successful",
#       "prometheus_engine_queries",
#       "prometheus_engine_queries_concurrent_max",
#       "prometheus_engine_query_duration_seconds",
#       "prometheus_evaluator_duration_seconds",
#       "prometheus_evaluator_iterations_missed_total",
#       "prometheus_evaluator_iterations_skipped_total",
#       "prometheus_evaluator_iterations_total",
#       "prometheus_local_storage_checkpoint_duration_seconds",
#       "prometheus_local_storage_checkpoint_last_duration_seconds",
#       "prometheus_local_storage_checkpoint_last_size_bytes",
#       "prometheus_local_storage_checkpoint_series_chunks_written",
#       "prometheus_local_storage_checkpointing",
#       "prometheus_local_storage_chunk_ops_total",
#       "prometheus_local_storage_chunks_to_persist",
#       "prometheus_local_storage_fingerprint_mappings_total",
#       "prometheus_local_storage_inconsistencies_total",
#       "prometheus_local_storage_indexing_batch_duration_seconds",
#       "prometheus_local_storage_indexing_batch_sizes",
#       "prometheus_local_storage_indexing_queue_capacity",
#       "prometheus_local_storage_indexing_queue_length",
#       "prometheus_local_storage_ingested_samples_total",
#       "prometheus_local_storage_maintain_series_duration_seconds",
#       "prometheus_local_storage_memory_chunkdescs",
#       "prometheus_local_storage_memory_chunks",
#       "prometheus_local_storage_memory_dirty_series",
#       "prometheus_local_storage_memory_series",
#       "prometheus_local_storage_non_existent_series_matches_total",
#       "prometheus_local_storage_open_head_chunks",
#       "prometheus_local_storage_out_of_order_samples_total",
#       "prometheus_local_storage_persist_errors_total",
#       "prometheus_local_storage_persistence_urgency_score",
#       "prometheus_local_storage_queued_chunks_to_persist_total",
#       "prometheus_local_storage_rushed_mode",
#       "prometheus_local_storage_series_chunks_persisted",
#       "prometheus_local_storage_series_ops_total",
#       "prometheus_local_storage_started_dirty",
#       "prometheus_local_storage_target_heap_size_bytes",
#       "prometheus_notifications_alertmanagers_discovered",
#       "prometheus_notifications_dropped_total",
#       "prometheus_notifications_queue_capacity",
#       "prometheus_notifications_queue_length",
#       "prometheus_rule_evaluation_failures_total",
#       "prometheus_sd_azure_refresh_duration_seconds",
#       "prometheus_sd_azure_refresh_failures_total",
#       "prometheus_sd_consul_rpc_duration_seconds",
#       "prometheus_sd_consul_rpc_failures_total",
#       "prometheus_sd_dns_lookup_failures_total",
#       "prometheus_sd_dns_lookups_total",
#       "prometheus_sd_ec2_refresh_duration_seconds",
#       "prometheus_sd_ec2_refresh_failures_total",
#       "prometheus_sd_file_read_errors_total",
#       "prometheus_sd_file_scan_duration_seconds",
#       "prometheus_sd_gce_refresh_duration",
#       "prometheus_sd_gce_refresh_failures_total",
#       "prometheus_sd_kubernetes_events_total",
#       "prometheus_sd_marathon_refresh_duration_seconds",
#       "prometheus_sd_marathon_refresh_failures_total",
#       "prometheus_sd_openstack_refresh_duration_seconds",
#       "prometheus_sd_openstack_refresh_failures_total",
#       "prometheus_sd_triton_refresh_duration_seconds",
#       "prometheus_sd_triton_refresh_failures_total",
#       "prometheus_target_interval_length_seconds",
#       "prometheus_target_scrape_pool_sync_total",
#       "prometheus_target_scrapes_exceeded_sample_limit_total",
#       "prometheus_target_skipped_scrapes_total",
#       "prometheus_target_sync_length_seconds",
#       "prometheus_treecache_watcher_goroutines",
#       "prometheus_treecache_zookeeper_failures_total",
#     ],
#   },
#   # logs - required: false
#   "logs" => nil,
# }

datadog_monitor 'gitlab' do
  init_config node['datadog']['gitlab']['init_config']
  instances node['datadog']['gitlab']['instances']
  logs node['datadog']['gitlab']['logs']
  use_integration_template true
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
