@test "agent binary exists" {
  [ -f /usr/bin/dd-agent ]
}

@test "agent is running" {
  run /etc/init.d/datadog-agent info
  [ $status -eq 0 ]
}
