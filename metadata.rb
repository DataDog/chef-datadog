name             'datadog'
maintainer       'Datadog'
maintainer_email 'package@datadoghq.com'
license          'Apache-2.0'
description      'Installs/Configures datadog components'
version          '4.15.0'
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

depends    'apt'

if Chef::VERSION < Gem::Version.new(14.0)
  depends 'chef_handler', '>= 1.2'
  depends 'sudo'
end

if Chef::VERSION < Gem::Version.new(15.3) ||
   Gem::Version.new(ENV['CHEF_VERSION']) < Gem::Version.new(15.3)
  depends 'yum', '< 7.0.0'
else
  depends 'yum'
end
