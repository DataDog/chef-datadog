@test "tcp_check.yaml exists" {
  [ -f /etc/dd-agent/conf.d/tcp_check.yaml ]
}

@test "tcp_check.yaml is correct" {
  export PYTHONPATH=/opt/datadog-agent/embedded/share
  export PATH=/opt/datadog-agent/embedded/bin:$PATH
  script='import yaml, json, sys; print json.dumps(yaml.load(sys.stdin.read()))'
  actual=$(cat /etc/dd-agent/conf.d/tcp_check.yaml | python -c "$script")
  expected='{"instances": [{"host": "localhost", "name": "test", "port": 1234}, {"port": 5678, "host": "localhost", "notify": ["user2@example.com", "pagerduty2"], "name": "test with notify"}], "init_config": {"notify": ["user1@example.com", "pagerduty1"]}}'
  echo "Expected: $expected"
  echo "Actual:   $actual"
  [ "x$actual" == "x$expected" ]
}
