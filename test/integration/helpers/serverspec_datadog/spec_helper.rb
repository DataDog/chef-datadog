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

# Shared helper for all serverspec tests
require 'json_spec'
require 'serverspec'
require 'yaml'

# manually determine if the platform is Windows or not
# Serverspec as of v2.24 cannot detect the OS family of Windows target hosts
# For reference see https://github.com/serverspec/serverspec/blob/master/WINDOWS_SUPPORT.md
if ENV['OS'] == 'Windows_NT'
  set :backend, :cmd
  # On Windows, set the target host's OS explicitly
  set :os, :family => 'windows'
  @agent_package_name = 'Datadog Agent'
  @agent_service_name = 'DatadogAgent'
  @agent_config_dir = "#{ENV['ProgramData']}/Datadog"
else
  set :backend, :exec
  @agent_package_name = 'datadog-agent'
  @agent_service_name = 'datadog-agent'
  @agent_config_dir = '/etc/datadog-agent'
end

set :path, '/sbin:/usr/local/sbin:$PATH' unless os[:family] == 'windows'
