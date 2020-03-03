name             'datadog'
maintainer       'Datadog'
maintainer_email 'package@datadoghq.com'
license          'Apache-2.0'
description      'Installs/Configures datadog components'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '4.2.1'
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

recipe 'datadog::default', 'Default'
recipe 'datadog::dd-agent', 'Installs the Datadog Agent'
recipe 'datadog::dd-handler', 'Installs a Chef handler for Datadog'
recipe 'datadog::repository', 'Installs the Datadog package repository'
recipe 'datadog::dogstatsd-ruby', 'Installs the Ruby dogstatsd package for custom metrics'
recipe 'datadog::ddtrace-ruby', 'Installs the Ruby ddtrace package for APM'

# integration-specific
recipe 'datadog::cassandra', 'Installs and configures the Cassandra integration'
recipe 'datadog::couchdb', 'Installs and configures the CouchDB integration'
recipe 'datadog::postfix', 'Installs and configures the Postfix integration'
