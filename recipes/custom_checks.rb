#
# Cookbook Name:: datadog
# Recipe:: custom_checks
#
# Copyright 2011-2017, Datadog
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

# Install your custom checks
# The custom check file will be pulled from the files of another cookbook, using
# the `cookbook_file` resource

# This recipe is included from datadog::dd-agent

# Examples:
# default['datadog']['custom_checks']['my_custom_check_1'] = {
#   'enabled' => true,
#   'cookbook' => 'my_cookbook_name', # cookbook to source the custom check file from
# }
# default['datadog']['my_custom_check_1']['instances'] = [
#   {
#     'url' => 'http://localhost:22222'
#   }
# ]

# default['datadog']['custom_checks']['my_custom_check_2'] = {
#   'enabled' => true,
#   'cookbook' => 'my_cookbook_name',
#   'source' => 'custom/path/my_custom_check.py' # custom path to where the check file resides relative to my_cookbook_name/files/
# }
# default['datadog']['my_custom_check_2']['init_config'] = {
#   'default_timeout' => 10
# }
# default['datadog']['my_custom_check_2']['instances'] = [
#   {
#     'url' => 'http://localhost:22222'
#   }
# ]
node['datadog']['custom_checks'].each do |check_name, custom_check|
  next unless custom_check['enabled']

  datadog_monitor check_name do
    init_config node['datadog'][check_name]['init_config']
    instances node['datadog'][check_name]['instances']
    custom_check true
    check_cookbook custom_check['cookbook']
    check_source custom_check['source']
  end
end
