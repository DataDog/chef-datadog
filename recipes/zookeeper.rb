#
# Cookbook Name:: datadog
# Recipe:: zookeeper
#

include_recipe 'datadog::dd-agent'

datadog_monitor 'zk' do
  instances node['datadog']['zookeeper']['instances']
  logs node['datadog']['zookeeper']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
