#
# Cookbook Name:: datadog
# Recipe:: integrations
#
# Copyright 2011-2015, Datadog
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

include_recipe 'datadog::repository' if node['datadog']['installrepo']

# Install all specified integrations
# example:
# default['datadog']['extra_packages']['twemproxy'] = {
#   'name' => 'dd-check-twemproxy',
#   'version' => '1.0.0-1'
# }
# default['datadog']['twemproxy']['instances'] = [
# {
#   'url' => 'http://localhost:22222'
# }
node['datadog']['extra_packages'].each do |name, options|
  package options['name'] do
    version options['version']
    action :install
  end

  datadog_monitor name do
    init_config node['datadog'][name]['init_config']
    instances node['datadog'][name]['instances']
    use_integration_template true
  end
end
