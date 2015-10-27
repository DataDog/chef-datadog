name             'datadog'
maintainer       'Datadog'
maintainer_email 'package@datadoghq.com'
license          'Apache 2.0'
description      'Installs/Configures datadog components'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.2.0'
source_url       'https://github.com/DataDog/chef-datadog' if respond_to? :source_url
issues_url       'https://github.com/DataDog/chef-datadog/issues' if respond_to? :issues_url

%w(
  amazon
  centos
  debian
  fedora
  redhat
  scientific
  ubuntu
  windows
).each do |os|
  supports os
end

depends          'apt' # We recommend '>= 2.1.0'. See CHANGELOG.md for details
depends          'chef_handler', '~> 1.1.0'
depends          'windows'
depends          'yum'

suggests         'sudo'

recipe 'datadog::default', 'Default'
recipe 'datadog::dd-agent', 'Installs the Datadog Agent'
recipe 'datadog::dd-handler', 'Installs a Chef handler for Datadog'
recipe 'datadog::repository', 'Installs the Datadog package repository'
recipe 'datadog::dogstatsd-python', 'Installs the Python dogstatsd package for custom metrics'
recipe 'datadog::dogstatsd-ruby', 'Installs the Ruby dogstatsd package for custom metrics'

# integration-specific
recipe 'datadog::cassandra', 'Installs and configures the Cassandra integration'
recipe 'datadog::couchdb', 'Installs and configures the CouchDB integration'
recipe 'datadog::postfix', 'Installs and configures the Postfix integration'
