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

  case node['datadog']['agent_major_version'].to_i
  when 7
    components = ['7']
  when 6
    components = ['6']
  when 5
    components = ['main']
  else
    Chef::Log.error('agent_major_version not supported.')
  end

  retries = node['datadog']['aptrepo_retries']
  keyserver = node['datadog']['aptrepo_use_backup_keyserver'] ? node['datadog']['aptrepo_backup_keyserver'] : node['datadog']['aptrepo_keyserver']
  # Add APT repository
  apt_repository 'datadog' do
    keyserver keyserver
    key 'A2923DFF56EDA6E76E55E492D3A80E30382E94DE'
    uri node['datadog']['aptrepo']
    distribution node['datadog']['aptrepo_dist']
    components components
    action :add
    retries retries
  end

  # Previous versions of the cookbook could create this repo file, make sure we remove it now
  apt_repository 'datadog-beta' do
    action :remove
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
      only_if "gpg --dry-run --quiet --with-fingerprint #{key_local_path} | grep 'A4C0 B90D 7443 CF6E 4E8A  A341 F106 8E14 E094 22B3' || gpg --dry-run --import --import-options import-show #{key_local_path} | grep 'A4C0B90D7443CF6E4E8AA341F1068E14E09422B3'"
      action :nothing
    end
  end

  case node['datadog']['agent_major_version'].to_i
  when 6, 7
    baseurl = URI.join(node['datadog']['yumrepo'], "#{node['datadog']['agent_major_version']}/", "#{node['kernel']['machine']}/").to_s
  when 5
    baseurl = node['datadog']['agent5_yumrepo']
  else
    Chef::Log.error('agent_major_version not supported.')
  end

  # Add YUM repository
  yum_repository 'datadog' do
    description 'datadog'
    baseurl baseurl
    proxy node['datadog']['yumrepo_proxy']
    proxy_username node['datadog']['yumrepo_proxy_username']
    proxy_password node['datadog']['yumrepo_proxy_password']
    gpgkey node['datadog']['yumrepo_gpgkey']
    gpgcheck true
    action :create
  end
when 'suse'
  # Import new RPM key
  if node['datadog']['yumrepo_gpgkey_new']
    # Download new RPM key
    new_key_local_path = ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY_E09422B3.public')
    remote_file 'DATADOG_RPM_KEY_E09422B3.public' do
      path new_key_local_path
      source node['datadog']['yumrepo_gpgkey_new']
      not_if 'rpm -q gpg-pubkey-e09422b3' # (key already imported)
      notifies :run, 'execute[rpm-import datadog key e09422b3]', :immediately
    end

    # Import key if fingerprint matches
    execute 'rpm-import datadog key e09422b3' do
      command "rpm --import #{new_key_local_path}"
      only_if "gpg --dry-run --quiet --with-fingerprint #{new_key_local_path} | grep 'A4C0 B90D 7443 CF6E 4E8A  A341 F106 8E14 E094 22B3' || gpg --dry-run --import --import-options import-show #{new_key_local_path} | grep 'A4C0B90D7443CF6E4E8AA341F1068E14E09422B3'"
      action :nothing
    end
  end

  old_key_local_path = ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY.public')
  remote_file 'DATADOG_RPM_KEY.public' do
    path old_key_local_path
    source node['datadog']['yumrepo_gpgkey']
    not_if 'rpm -q gpg-pubkey-4172a230' # (key already imported)
    notifies :run, 'execute[rpm-import datadog key 4172a230]', :immediately
  end

  # Import key if fingerprint matches
  execute 'rpm-import datadog key 4172a230' do
    command "rpm --import #{old_key_local_path}"
    only_if "gpg --dry-run --quiet --with-fingerprint #{old_key_local_path} | grep '60A3 89A4 4A0C 32BA E3C0  3F0B 069B 56F5 4172 A230' || gpg --dry-run --import --import-options import-show #{old_key_local_path} | grep '60A389A44A0C32BAE3C03F0B069B56F54172A230'"
    action :nothing
  end

  case node['datadog']['agent_major_version'].to_i
  when 6, 7
    baseurl = URI.join(node['datadog']['yumrepo_suse'], "#{node['datadog']['agent_major_version']}/", "#{node['kernel']['machine']}/").to_s
  when 5
    baseurl = node['datadog']['agent5_yumrepo_suse']
  else
    Chef::Log.error('agent_major_version not supported.')
  end

  # Add YUM repository
  zypper_repository 'datadog' do
    description 'datadog'
    baseurl baseurl
    gpgkey node['datadog']['yumrepo_gpgkey']
    gpgautoimportkeys false
    gpgcheck false
    action :create
  end
end
