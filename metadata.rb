name             "datadog"
maintainer       "Datadog"
maintainer_email "package@datadoghq.com"
license          "Apache 2.0"
description      "Installs/Configures datadog components"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.0"

depends          "apt"
depends          "chef_handler", "~> 1.1.0"
depends          "yum"

recipe "datadog::default", "Default"
recipe "datadog::dd-agent", "Installs the Datadog Agent"
recipe "datadog::dd-handler", "Installs a Chef handler for Datadog"
recipe "datadog::repository", "Installs the Datadog package repository"
recipe "datadog::dogstatsd-python", "Installs the Python dogstatsd package for custom metrics"
recipe "datadog::dogstatsd-ruby", "Installs the Ruby dogstatsd package for custom metrics"
