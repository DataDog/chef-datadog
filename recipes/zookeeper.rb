#
# Cookbook Name:: datadog
# Recipe:: zookeeper
#

include_recipe 'datadog::dd-agent'

datadog_monitor 'zk' do
  instances node['datadog']['zookeeper']['instances']
  action :add
  notifies :restart, 'service[datadog-agent]'
end
