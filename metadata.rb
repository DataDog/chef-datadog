name             'datadog'
maintainer       'Datadog'
maintainer_email 'package@datadoghq.com'
license          'Apache-2.0'
description      'Installs/Configures datadog components'
version          '4.12.0'
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

depends    'chef_handler', '>= 1.2'

if Chef::VERSION < Gem::Version.new(12.9)
  depends    'apt < 6.0.0'
else
  depends    'apt'
end

if Chef::VERSION < Gem::Version.new(12.4)
  depends    'yum', '>= 3.0, < 5.0'
elsif Chef::VERSION < Gem::Version.new(15.3)
  depends    'yum', '>= 3.0, < 7.0'
else
  depends    'yum', '>= 3.0'
end

