#
# Cookbook:: datadog
# Recipe:: disk
#
# This recipe exists to apply (optional) configuration to the disk integration
# This recipe does not need to be included to use the disk integration,
# but it allows you to override some defaults that the disk integration
# provides.
# For more information on the integration itself, see:
# https://docs.datadoghq.com/integrations/disk/

include_recipe 'datadog::dd-agent'

# example configuration:
# node['datadog']['disk']['instances'] = [
#   {
#     'use_mount' => true,
#     'excluded_filesystems' => [
#       'tmpfs'
#     ],
#     'excluded_disks' => [
#       '/dev/sda1',
#       '/dev/sda2'
#     ],
#     'excluded_disk_re' => '/dev/sde.*',
#     'tag_by_filesystem' => false,
#     'excluded_mountpoint_re' => '/mnt/somebody-elses-problem.*',
#     'all_partitions' => false
#   }
# ]

datadog_monitor 'disk' do
  instances node['datadog']['disk']['instances']
  init_config nil
  logs node['datadog']['disk']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
