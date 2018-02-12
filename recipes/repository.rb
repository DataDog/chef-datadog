#
# Cookbook Name:: datadog
# Recipe:: repository
#
# Copyright 2013-2015, Datadog
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

case node['platform_family']
when 'debian'
  include_recipe 'apt'

  package 'install-apt-transport-https' do
    package_name 'apt-transport-https'
    action :install
  end

  # Trust new APT key
  execute 'apt-key import key 382E94DE' do
    command 'apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 A2923DFF56EDA6E76E55E492D3A80E30382E94DE'
    not_if 'apt-key list | grep 382E94DE'
  end

  # Add APT repository
  apt_repository 'datadog' do
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key 'C7A7DA52'
    uri node['datadog']['aptrepo']
    distribution node['datadog']['aptrepo_dist']
    components ['main']
    action :add
  end

  apt_repository 'datadog-beta' do
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key 'C7A7DA52'
    uri node['datadog']['agent6_aptrepo']
    distribution node['datadog']['agent6_aptrepo_dist']
    components node['datadog']['agent6_aptrepo_components']
    if node['datadog']['agent6'] &&
       (node['datadog']['agent6_aptrepo'] != node['datadog']['aptrepo'] ||
       node['datadog']['agent6_aptrepo_dist'] != node['datadog']['aptrepo_dist'])
      # add the beta repo iff:
      # * agent6 is selected (avoid automatic upgrades to agent6 if it's not), and
      # * the node is configured to use a different repo than the agent5 (avoid duplicate repos)
      action :add
    else
      action :remove
    end
  end
when 'rhel', 'fedora', 'amazon'
  # Import new RPM key
  if node['datadog']['yumrepo_gpgkey_new']
    # gnupg is required to check the downloaded key's fingerprint
    package 'gnupg' do
      action :install
    end

    # Download new RPM key
    key_local_path = ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY_E09422B3.public')
    remote_file 'DATADOG_RPM_KEY_E09422B3.public' do
      path key_local_path
      source node['datadog']['yumrepo_gpgkey_new']
      not_if 'rpm -q gpg-pubkey-e09422b3' # (key already imported)
      notifies :run, 'execute[rpm-import datadog key e09422b3]', :immediately
    end

    # Import key if fingerprint matches
    execute 'rpm-import datadog key e09422b3' do
      command "rpm --import #{key_local_path}"
      only_if "gpg --dry-run --quiet --with-fingerprint #{key_local_path} | grep 'A4C0 B90D 7443 CF6E 4E8A  A341 F106 8E14 E094 22B3'"
      action :nothing
    end
  end

  # Add YUM repository
  yum_repository 'datadog' do
    name 'datadog'
    description 'datadog'
    if node['datadog']['agent6']
      baseurl node['datadog']['agent6_yumrepo']
    else
      baseurl node['datadog']['yumrepo']
    end
    proxy node['datadog']['yumrepo_proxy']
    proxy_username node['datadog']['yumrepo_proxy_username']
    proxy_password node['datadog']['yumrepo_proxy_password']
    gpgkey node['datadog']['yumrepo_gpgkey']
    gpgcheck true
    action :create
  end
end
