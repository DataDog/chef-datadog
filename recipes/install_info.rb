#
# Cookbook:: datadog
# Recipe:: install_info
#
# Copyright:: 2011-2020, Datadog
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

# Create install info metadata to send installation metadata to Datadog
# example:
# default['datadog']['install_info_enabled'] = true

return if Chef::Datadog.agent_major_version(node) == 5

def flare_path
  if platform_family?('windows')
    "#{ENV['ProgramData']}/Datadog/install_info"
  else
    '/etc/datadog-agent/install_info'
  end
end

template flare_path do
  if node['datadog']['install_info_enabled']
    action :create
  else
    action :delete
  end

  if platform_family?('windows')
    inherits true # Agent 6/7 rely on inheritance being enabled. Reset it in case it was disabled when installing Agent 5.
  else
    owner 'dd-agent'
    mode '600'
  end

  source 'install_info.yaml.erb'

  variables(
    chef_version: Chef::VERSION,
    cookbook_version: Chef::Datadog.cookbook_version(run_context)
  )
  sensitive true
end
