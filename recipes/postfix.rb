#
# Cookbook Name:: datadog
# Recipe:: postfix
#

# Monitor postfix
#
# Assuming you have 2 instances "prod" and "test", you will need to set
# up the following attributes at some point in your Chef run, in either
# a role or another cookbook.
#
# node['datadog']['postfix']['instances'] = [
#   {
#     'directory' => '/var/spool/postfix',
#     'queues' => ['incoming', 'active', 'deferred'],
#     'tags' => ['prod', 'postfix_core']
#   },
#   {
#     'directory' => '/var/spool/postfix',
#     'queues' => ['bounce'],
#     'tags' => ['test']
#   }
# ]

include_recipe 'datadog::dd-agent'
include_recipe 'sudo' # ~FC007 uses `suggests`

postfix_instances = Array(node['datadog']['postfix']['instances'])
postfix_commands = postfix_instances.map do |instance|
  "/usr/bin/find #{instance['directory']}"
end

sudo 'dd-agent-find-postfix' do
  user 'dd-agent'
  nopasswd true
  commands postfix_commands.uniq
  only_if { postfix_instances.any? }
end

datadog_monitor 'postfix' do
  instances postfix_instances
end
