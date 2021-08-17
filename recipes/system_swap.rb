#
# Cookbook:: datadog
# Recipe:: system_swap
#
include_recipe '::dd-agent'

datadog_monitor 'system_swap'
