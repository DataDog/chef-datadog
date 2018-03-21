name             'datadog'
maintainer       'Datadog'
maintainer_email 'package@datadoghq.com'
license          'Apache-2.0'
description      'Installs/Configures datadog components'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.14.2'
chef_version     '>= 10.14' if respond_to? :chef_version
source_url       'https://github.com/DataDog/chef-datadog' if respond_to? :source_url
issues_url       'https://github.com/DataDog/chef-datadog/issues' if respond_to? :issues_url

%w[
  amazon
  centos
  debian
  fedora
  redhat
  scientific
  ubuntu
  windows
].each do |os|
  supports os
end

depends          'apt' # We recommend '>= 2.1.0'. See CHANGELOG.md for details
depends          'chef_handler', '>= 1.1' # We recommend '~> 1.3' with Chef < 12. See CHANGELOG.md for details
depends          'windows' # We recommend '< 1.39.0' if running Chef >= 12.6. See README.md for details
depends          'yum', '>= 3.0' # Use '~> 3.0' with Chef < 12

suggests         'sudo' # ~FC052

recipe 'datadog::default', 'Default'
recipe 'datadog::dd-agent', 'Installs the Datadog Agent'
recipe 'datadog::dd-handler', 'Installs a Chef handler for Datadog'
recipe 'datadog::repository', 'Installs the Datadog package repository'
recipe 'datadog::dogstatsd-python', 'Installs the Python dogstatsd package for custom metrics'
recipe 'datadog::dogstatsd-ruby', 'Installs the Ruby dogstatsd package for custom metrics'
recipe 'datadog::ddtrace-python', 'Installs the Python ddtrace package for APM'
recipe 'datadog::ddtrace-ruby', 'Installs the Ruby ddtrace package for APM'

# integration-specific
recipe 'datadog::cassandra', 'Installs and configures the Cassandra integration'
recipe 'datadog::couchdb', 'Installs and configures the CouchDB integration'
recipe 'datadog::postfix', 'Installs and configures the Postfix integration'
