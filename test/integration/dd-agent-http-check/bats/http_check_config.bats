@test "http_check.yaml exists" {
  [ -f /etc/dd-agent/conf.d/http_check.yaml ]
}

@test "http_check.yaml is correct" {
  export PYTHONPATH=/opt/datadog-agent/embedded/share
  export PATH=/opt/datadog-agent/embedded/bin:$PATH
  script='import yaml, json, sys; print json.dumps(yaml.load(sys.stdin.read()))'
  actual=$(cat /etc/dd-agent/conf.d/http_check.yaml | python -c "$script")
  expected='{"instances": [{"url": "http://localhost/", "name": "test"}, {"url": "http://localhost/", "name": "test with notify", "notify": ["user@example.com", "pagerduty"]}], "init_config": null}'
  echo "Expected: $expected"
  echo "Actual:   $actual"
  [ "x$actual" == "x$expected" ]
}
