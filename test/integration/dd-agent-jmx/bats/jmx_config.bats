@test "jmx.yaml exists" {
  [ -f /etc/dd-agent/conf.d/jmx.yaml ]
}

@test "jmx.yaml is correct" {
  export PYTHONPATH=/usr/share/datadog/agent/
  script='import yaml, json, sys; print json.dumps(yaml.load(sys.stdin.read()))'
  actual=$(cat /etc/dd-agent/conf.d/jmx.yaml | python -c "$script")
  expected='{"instances": [{"host": "localhost", "port": 9999, "conf": [{"include": {"domain": "domain0"}}, {"include": {"domain": "domain1"}}]}], "init_config": null}'
  echo "Expected: $expected"
  echo "Actual: $actual"
  [ "x$actual" == "x$expected" ]
}
