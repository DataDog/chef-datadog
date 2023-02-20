name             'datadog'
maintainer       'Datadog'
maintainer_email 'package@datadoghq.com'
license          'Apache-2.0'
description      'Installs/Configures datadog components'
version          '4.17.0'
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

if Chef::VERSION < Gem::Version.new(14)
  # The chef_handler cookbook is shipped as part of Chef >= 14,
  # so from Chef >= 14 chef_handler cookbook is deprecated.
  depends 'chef_handler', '>= 1.2'
end
depends    'apt' # Use '< 6.0.0' with Chef < 12.9
depends    'yum', '>= 3.0' # Use '< 5.0' with Chef < 12.14
