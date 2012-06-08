maintainer       "Datadog"
maintainer_email "package@datadoghq.com"
license          "Apache 2.0"
description      "Installs/Configures datadog components"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.11"

depends          "apt"
depends          "chef_handler"
depends          "yum"

recipe "datadog::default", "Default"
recipe "datadog::dd-agent", "Installs the Datadog Agent"
recipe "datadog::dd-handler", "Installs a Chef handler for Datadog"
