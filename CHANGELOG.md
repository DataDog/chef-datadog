Changes
=======

# v1.0.1 - 2013-05-14

* Fixed iis and rabbitmq template syntax - #58 @gregf
* Updated style/spacing in ActiveMQ template
* Updated test suite to validate cookbook & templates
* Updated chefignore to clean the built cookbook from containing cruft

# v1.0.0 - 2013-05-06

* **BREAKING CHANGE**: Moved all attributes into `datadog` namespace - #46 (#23, #26)

  Reasoning behind this was that originally we attempted to auto-detect many common attributes and deploy automatic monitoring for them.
  We found that since inclusion of the `datadog` cookbook early in the run list caused the compile phase to be populated with our defaults (mostly `nil`), instead of the desired target, and namespacing of the attributes became necessary.

* **NEW PROVIDER**: Added a new `datadog_monitor` provider for integration use

  The new provider is used in many pre-provided integration recipes, such as `datadog::apache`.
  This enables a run list to include this recipe, as well as populate a node attribute with the needed instance details to monitor the given service

* Updated dependencies in Gemfile, simplifies travis build - #34, #55
* Much improved test system (chefspec, test-kitchen) - #35 & others
* Tests against multiple versions of Chef - #18
* Added language-specific recipes for installing `dogstatsd` - (#28)
* Added ability to control `dogstatsd` from agent config via attribute - #27
* Placed the `dogstatsd` log file in `/var/log/` instead of `/tmp`
* Added attribute to configure dogstreams in `datadog.conf` - #37
* Updated for `platform_family` semantics
* Added `node['datadog']['agent_version']` attribute
* (Handler Recipe) Better handling of EC2 instance ID for Handler - #44
* Updated for agent 3.6.x logging syntax
* Generated config file removes some whitespace - #56
* Removed dependency on `yum::epel`, only uses `yum` for the `repository` recipe


## v0.1.4
* Quick fix for backporting test code to support upload in ruby 1.8.7

## v0.1.3
* Work-around for COOK-2171

## v0.1.2
* Fixed typo in jmx section

## v0.1.1
* Added support for postgres, redis & memcached
* `dd-agent` - updated to include more platforms
* `dd-handler` - updated to leverage `chef_gem` resource if available
* Updated copyright for 2012
* Updated syntax for node attribute accessors
* Some syntax styling fixes
* Added agent logging configuration
* Removed extraneous dependencies
* Added automated testing suite

## v0.0.12
* Updated for CentOS dependencies

## v0.0.11
* Link to github repository.

## v0.0.10
* `dd-handler` - Corrects attribute name.

## v0.0.9
* `dd-agent` - Adds an explicit varnish attribute.

## v0.0.8
* `dd-agent` - Add varnish support.

## v0.0.7
* `dd-agent` - default to using instance IDs as hostnames when running dd-agent on EC2

## v0.0.5
* `dd-agent` - Full datadog.conf template using attributes (thanks @drewrothstein)

## v0.0.4
* `dd-agent` - Added support for Nagios PerfData and Graphite.

## v0.0.3
* `dd-agent` - Added support for RPM installs - Red Hat, CentOS, Scientific, Fedora

## v0.0.2
* Initial refactoring, including the `dd-agent` cookbook here
* Adding chef-handler-datadog to report to the newsfeed
* Added ruby-dev dependency