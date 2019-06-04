@test "kafka.yaml exists" {
  [ -f /etc/datadog-agent/conf.d/kafka_consumer.yaml ]
}

@test "kafka.yaml is correct" {
  export PYTHONPATH=/usr/share/datadog/agent/
  script='import yaml, json, sys; print json.dumps(yaml.load(sys.stdin.read()))'
  actual=$(cat /etc/datadog-agent/conf.d/kafka_consumer.yaml | python -c "$script")

  expected='{"instances": [{"zk_connect_str": "localhost:2181", "kafka_connect_str": "localhost:19092", "consumer_groups": {"my_consumer": {"my_topic": [0, 1, 4, 12]}}, "zk_prefix": "/0.8"}], "init_config": null}'

  echo "Expected: $expected"
  echo "Actual:   $actual"
  [ "x$actual" == "x$expected" ]
}




