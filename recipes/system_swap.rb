#
# Cookbook Name:: datadog
# Recipe:: system_swap
#
include_recipe 'datadog::dd-agent'

datadog_monitor 'system_swap'
