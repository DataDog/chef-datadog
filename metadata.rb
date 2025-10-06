name             'datadog'
maintainer       'Datadog'
maintainer_email 'package@datadoghq.com'
license          'Apache-2.0'
description      'Installs/Configures datadog components'
version          '4.22.3'
chef_version     '>= 12.7'
source_url       'https://github.com/DataDog/chef-datadog'
issues_url       'https://github.com/DataDog/chef-datadog/issues'

%w[
  amazon
  centos
  debian
  fedora
  redhat
  scientific
  ubuntu
  windows
  suse
].each do |os|
  supports os
end

current_chef_version = if Chef::VERSION.instance_of? String
                         # For Chef < 13.1.33 Chef::VERSION was a String
                         Gem::Version.new(Chef::VERSION.to_f)
                       else
                         # Else Chef::VERSION is already a VersionString
                         Chef::VERSION
                       end

if current_chef_version < Gem::Version.new(14)
  # The chef_handler cookbook is shipped as part of Chef >= 14,
  # so from Chef >= 14 chef_handler cookbook is deprecated.
  depends 'chef_handler', '>= 1.2'
end

# Use '< 6.0.0' with Chef < 12.9
if current_chef_version < Gem::Version.new(12.9)
  depends 'apt', '< 6.0'
else
  depends 'apt'
end

# Must be '>= 3.0' and '< 5.0' with Chef < 12.14
# Chef allows only one constraint and '~> 3.0' means '>= 3.0' and '< 4.0'
if current_chef_version < Gem::Version.new(12.14)
  depends 'yum', '~> 3.0'
else
  depends 'yum', '>= 3.0'
end
