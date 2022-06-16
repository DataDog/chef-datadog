#
# Cookbook:: datadog
# Recipe:: _install-fips-proxy-linux
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

# Install the Apt/Yum repository if enabled
include_recipe '::repository' if node['datadog']['installrepo']

dd_fips_proxy_version = Chef::Datadog.fips_proxy_version(node)
dd_fips_proxy_package_name = node['datadog']['fips_proxy_package_name']

package_action = node['datadog']['fips_proxy_package_action']

package_retries = node['datadog']['fips_proxy_package_retries']
package_retry_delay = node['datadog']['fips_proxy_package_retry_delay']

# Install the regular package
case node['platform_family']
when 'debian'
  apt_package dd_fips_proxy_package_name do
    version dd_fips_proxy_version
    retries package_retries unless package_retries.nil?
    retry_delay package_retry_delay unless package_retry_delay.nil?
    action package_action # default is :install
    options '--force-yes' if node['datadog']['fips_proxy_allow_downgrade']
  end

  apt_package 'datadog-signing-keys' do
    retries package_retries unless package_retries.nil?
    retry_delay package_retry_delay unless package_retry_delay.nil?
    action :upgrade
  end
when 'rhel', 'fedora', 'amazon'
  if platform_family?('rhel') && node['platform_version'].to_i >= 8 && !platform?('amazon') ||
     platform_family?('fedora') && node['platform_version'].to_i >= 28
    # yum_package doesn't work on RHEL 8 and Fedora >= 28
    # dnf_package only works on RHEL 8 / Fedora >= 28 if Chef 15+ is used
    dnf_package dd_fips_proxy_package_name do
      version dd_fips_proxy_version
      retries package_retries unless package_retries.nil?
      retry_delay package_retry_delay unless package_retry_delay.nil?
      action package_action # default is :install
    end
  else
    yum_package dd_fips_proxy_package_name do
      version dd_fips_proxy_version
      retries package_retries unless package_retries.nil?
      retry_delay package_retry_delay unless package_retry_delay.nil?
      action package_action # default is :install
      allow_downgrade node['datadog']['fips_proxy_allow_downgrade']
    end
  end
when 'suse'
  zypper_package dd_fips_proxy_package_name do # ~FC009
    version dd_fips_proxy_version
    retries package_retries unless package_retries.nil?
    retry_delay package_retry_delay unless package_retry_delay.nil?
    action package_action # default is :install
    # allow_downgrade is only suported for zypper_package since Chef Client 13.6
    allow_downgrade node['datadog']['fips_proxy_allow_downgrade'] if respond_to?(:allow_downgrade)
  end
end
