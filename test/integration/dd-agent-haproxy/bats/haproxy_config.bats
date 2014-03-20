@test "haproxy.yaml exists" {
  [ -f /etc/dd-agent/conf.d/haproxy.yaml ]
}

@test "haproxy.yaml is correct" {
  export PYTHONPATH=/usr/share/datadog/agent/
  script='import yaml, json, sys; print json.dumps(yaml.load(sys.stdin.read()))'
  actual=$(cat /etc/dd-agent/conf.d/haproxy.yaml | python -c "$script")
  expected='{"instances": [{"username": "admin", "collect_aggregates_only": true, "password": "sekret", "url": "http://localhost:22002/status", "collect_status_metrics": true, "status_check": false}], "init_config": null}'
  echo "Expected: $expected"
  echo "Actual:   $actual"
  [ "x$actual" == "x$expected" ]
}
