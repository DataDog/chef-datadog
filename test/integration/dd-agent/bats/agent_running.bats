@test "agent binary exists" {
  [ -f /usr/bin/dd-agent ]
}

@test "agent is running" {
  run /etc/init.d/datadog-agent status
  [ "$status" -eq 0 ]
}

@test "info returns an OK" {
  run /etc/init.d/datadog-agent info
  [ "$status" -eq 0 ]
  [[ "$output" =~ "OK" ]]
}

@test "info returns no ERRORs" {
  run /etc/init.d/datadog-agent info
  [[ ! "$output" =~ "ERROR" ]]
}
