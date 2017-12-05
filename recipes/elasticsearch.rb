include_recipe 'datadog::dd-agent'

# Monitor elasticsearch
#
# Assuming you have 2 clusters "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node['datadog']['elasticsearch']['instances'] = [
#   {
#     :url => 'http://localhost:9200',
#     ::tags => ['env:test']
#   },
#   {
#     :url => 'http://localhost:19200',
#     :username => 'myuser',
#     :password => 'mypass',
#     :tags => ['env:prod']
#   }
# ]
#
# Additional flags:
#
# If you enable the "pshard_stats" flag, statistics over primary shards
# will be collected by the check and sent to the backend with the
# 'elasticsearch.primary' prefix. It is particularly useful if you want to
# get certain metrics without taking replicas into account. For instance,
# 'elasticsearch.primaries.docs.count` will give you the total number of
# documents in your indexes WITHOUT counting duplicates due to the existence
# of replica shards in your ES cluster
#
# The "shard_level_metrics" flag enables metrics and service checks on a per-
# shard basis (all the information is fetched under the /_stats?level=shards
# endpoint). The metrics and service check sent for each shard are named as
# such: elasticsearch.shard.metric.name .
# The shard name is computed according to elasticsearch's documentation. Each
# primary shard is named Pi (ex: P0, P1, P2...) and every replica shards will
# be named Ri (R0, R1, R2). In case the number of replicas is superior to 1,
# we stick to the following convention for shard names : Rx_y where x is the
# number of the associated primary shard while y is the replica number.
#
# Plase note that shard-level metrics will get the following extra tags:
# es_node:<node_name>, es_shard:<shard_name>, es_index:<index_name> and
# es_role:(primary|replica). They will also carry a "shard_specific" tag. It
# should enable you to slice and dice as you please in your DatadogHQ.
#
# Example:
#
# node['datadog']['elasticsearch']['instances'] = [
#   {
#     :url => 'http://localhost:9200',
#     :tags => ['env:test'],
#     :pshard_stats => true,
#     :shard_level_metrics: true
#   }
# ]
#

datadog_monitor 'elastic' do
  instances node['datadog']['elasticsearch']['instances']
  logs node['datadog']['elasticsearch']['logs']
end
