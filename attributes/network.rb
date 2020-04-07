default['datadog']['network']['instances'] = [
  {
    'collect_connection_state' => 'false',
    'collect_count_metrics' => 'false',
    'combine_connection_states' => 'true',
    'excluded_interfaces' => ['lo', 'lo0']
  }
]
