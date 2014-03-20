@test "mongo.yaml exists" {
  [ -f /etc/dd-agent/conf.d/mongo.yaml ]
}

@test "mongo.yaml is correct" {
  export PYTHONPATH=/usr/share/datadog/agent/
  script='import yaml, json, sys; print json.dumps(yaml.load(sys.stdin.read()))'
  actual=$(cat /etc/dd-agent/conf.d/mongo.yaml | python -c "$script")
  expected='{"instances": [{"server": "mongodb://localhost:27017"}], "init_config": null}'
  echo "Expected: $expected"
  echo "Actual:   $actual"
  [ "x$actual" == "x$expected" ]
}
