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

# Run this recipe to completely remove the Datadog Agent

# On Windows, this recipe works only with Chef >= 12.6

# Importing apt_sources_list_file variable from recipe_helpers.rb
apt_sources_list_file = Chef::Datadog.apt_sources_list_file

case node['os']
when 'linux'
  # First remove the datadog-agent package
  package 'datadog-agent' do
    action :purge
  end

  # Then remove the installation files (depending on the OS: sources_list file, datadog-signing-keys package...)
  case node['platform_family']
  when 'amazon', 'rhel' # 'rhel' includes redhat, centos, rocky, scientific and almalinux
    yum_repository 'datadog' do
      action :remove
    end
  when 'debian' # 'debian' includes debian and ubuntu
    apt_package 'datadog-signing-keys' do
      action :purge
    end
    file apt_sources_list_file do
      action :delete
    end
  when 'suse'
    zypper_repository 'datadog' do
      action :remove
    end
  end

when 'windows'
  # Remove the datadog-agent package (no need to remove other files as for Linux)
  package 'Datadog Agent' do
    action :remove
  end
end
