name             'datadog'
maintainer       'Datadog'
maintainer_email 'package@datadoghq.com'
license          'Apache-2.0'
description      'Installs/Configures datadog components'
version          '4.10.0'
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
depends    'apt' # Use '< 6.0.0' with Chef < 12.9
depends    'yum', '>= 3.0' # Use '< 5.0' with Chef < 12.14
