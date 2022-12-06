#
# Cookbook:: datadog
# Recipe:: disk
#
# Copyright:: 2011-Present, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This recipe exists to apply (optional) configuration to the disk integration
# This recipe does not need to be included to use the disk integration,
# but it allows you to override some defaults that the disk integration
# provides.
# For more information on the integration itself, see:
# https://docs.datadoghq.com/integrations/disk/

include_recipe '::dd-agent'

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
