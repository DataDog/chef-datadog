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

  package 'apt-transport-https' do
    action :install
  end

  apt_repository 'datadog' do
    keyserver 'hkp://keyserver.ubuntu.com:80'
    key 'C7A7DA52'
    uri node['datadog']['aptrepo']
    distribution node['datadog']['aptrepo_dist']
    components ['main']
    action :add
  end

when 'rhel', 'fedora'
  include_recipe 'yum'

  yum_repository 'datadog' do
    name 'datadog'
    description 'datadog'
    baseurl node['datadog']['yumrepo']
    proxy node['datadog']['yumrepo_proxy']
    proxy_username node['datadog']['yumrepo_proxy_username']
    proxy_password node['datadog']['yumrepo_proxy_password']
    gpgkey node['datadog']['yumrepo_gpgkey']
    action :create
  end
end
