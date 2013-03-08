# monitor cassandra
include_recipe "datadog::dd-agent"
datadog_ddmonitor "cassandra"
