# monitor cassandra
include_recipe "datadog::dd-agent"
monitor "cassandra"
