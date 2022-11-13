#
# Cookbook:: datadog
# Recipe:: dd-fips-proxy
#
# Copyright:: 2011-2015, Datadog
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

require 'yaml' # Our erb templates need this

is_windows = platform_family?('windows')

# Install the agent
if is_windows
  raise 'Windows currently unsupported for the datadog FIPS proxy.'
else
  include_recipe '::_install-fips-proxy-linux'
end

# Set the Datadog FIPS proxy service enable or disable
fips_proxy_enable = node['datadog']['fips_proxy_enable'] ? :enable : :disable
# Set the Datadog FIPS proxy service startup action
fips_proxy_start = node['datadog']['fips_proxy_start'] ? :start : :stop

# Common configuration
service_provider = Chef::Datadog.service_provider(node)

service_name = 'datadog-fips-proxy'

file '/etc/datadog-fips-proxy/datadog-fips-proxy.cfg' do
  owner 'root'
  group 'root'
  mode 0766
  content ::File.open('/etc/datadog-fips-proxy/datadog-fips-proxy.cfg.example').read
  not_if { ::File.exist?('/etc/datadog-fips-proxy/datadog-fips-proxy.cfg') }
  action :create
end

service 'datadog-fips-proxy' do
  service_name service_name
  action [fips_proxy_enable, fips_proxy_start]
  provider service_provider unless service_provider.nil?
  supports :restart => true, :status => true, :start => true, :stop => true

  # HACK: the restart can fail when we hit systemd's restart limits (by default, 5 starts every 10 seconds)
  # To workaround this, retry once after 5 seconds, and a second time after 10 seconds
  retries 2
  retry_delay 5
end
