Where to Find the Code
======================
To submit issues and patches please visit https://github.com/DataDog/cookbooks.

Datadog Cookbook
================

Chef recipes to deploy Datadog's components and configuration automatically.

Requirements
============
- python >= 2.6
- chef >= 0.9

Platform
--------

* Debian, Ubuntu, RedHat, CentOS

Cookbooks
---------

The following Opscode cookbooks are dependencies:

* apt
* chef_handler
* yum::epel


Attributes
==========

* `node['datadog']['api_key']`    	= This needs to be retrieved from your Account Settings page.
* `node['datadog']['application_key']`= There are none by default. Visit the Account Settings page to create a new Application Key, to be used in conjunction with your API key.
* `node['datadog']['url']` 			= The location of where Datadog is hosted. Should never change.
* `node['datadog']['repo']` 			= Where the Datadog-maintained packages are located. Should never change.
* `node['datadog']['debug']` 			= Will trigger heavy logging to /tmp/dd-agent.log
* `node['datadog']['use_ec2_instance_id']` = Whether to use the instance-id in lieu of hostname when running on EC2. No effect on non-EC2 servers.
* `node['datadog']['use_mount']`      = Whether to use the mount point instead of the device name for all I/O metrics.

apache
-------
* `node['apache']['status_url']` 		= Url to Apache's status page. Must have mod_status installed.  See http://httpd.apache.org/docs/2.0/mod/mod_status.html for details.

ganglia
-------
* `node['ganglia']['url']` 			= Ganglia host where gmetad is running
* `node['ganglia']['port']` 			= Ganglia port where gmetad is running

graphite
--------
* `node['datadog']['graphite']`       = Turns the agent into a Graphite carbon relay.
* `node['datadog']['graphite_port']`  = Port that the carbon relay will listen on.

mysql
-------
* `node['mysql']['server']`			= MySQL host
* `node['mysql']['user']`				= MySQL user. It only runs "SHOW STATUS" queries, which doesn't require any privileges, so you should consider creating a separate, unprivileged user.
* `node['mysql']['pass']`				= MySQL user's password

nginx
-------
* `node['nginx']['status_url']`		= Url to nginx's status page. Must have http_stub_status_module installed.  See http://wiki.nginx.org/HttpStubStatusModule for details.

rabbitmq
-------
* `node['rabbitmq']['status_url']`	= Url to RabbitMQ's status page. Must have rabbitmq-status plugin installed.  See http://www.lshift.net/blog/2009/11/30/introducing-rabbitmq-status-plugin for details.
* `node['rabbitmq']['user']`			= RabbitMQ user
* `node['rabbitmq']['pass']`			= RabbitMQ user's password

mongodb
-------
* `node['mongodb']['server']`			= MongoDB uri. For example: mongodb://my_user:my_pass@localhost/my_db

couchdb
-------
* `node['couchdb']['server']`			= CouchDB host

jenkins
-------
* `node['jenkins']['home_dir']`		= Path to Jenkins's home directory

nagios
-------
* `node['nagios']['log_dir']`			= Path to Nagios's event log file
* `node['nagios']['conf_dir']`		= If you use perfdata, dd-agent can import automatically and in real-time performance data collected by nagios.  For more information on perfdata configuration, please refer to http://nagios.sourceforge.net/docs/3_0/perfdata.html.  Path to Nagios' ***configuration*** file where the properties host|service_perfdata_file and host|service_perfdata_file_template are defined.

cassandra
-------
* `node['cassandra']['host']`			= Cassandra host
* `node['cassandra']['port']`			= Cassandra port
* `node['cassandra']['nodetool']`		= Path to nodetool

java
-------
* `node['jvm_jmx']['server']`			= JMX server:port to connect to
* `node['jvm_jmx']['user']`			= JMX user to log in with, if needed
* `node['jvm_jmx']['pass']`			= Password for the configured JMX user
* `node['jvm_jmx']['name']`			= Name to report the statistics for this java VM. This will allow to monitor several JVMs running on the same machine.

tomcat
-------
* `node['tomcat_jmx']['server']`		= host:port to connect to. Must be configured in tomcat setenv.sh or similar
* `node['tomcat_jmx']['user']`		= JMX user to log in with, if needed
* `node['tomcat_jmx']['pass']`		= Password for the configured JMX user

varnish
-------
* `node['varnish']`                  = if true, will invoke `varnishstat` on the server to gather varnish metrics.

memcached
---------
* `node['memcached']['listen']`       = memcached address; if 0.0.0.0 dd-agent will connect via the loopback address.
* `node['memcached']['port']`         = memcached port

redis
-----
* `node['redis']['server']['addr']`    = redis server address
* `node['redis']['server']['port']`    = redis server port

Recipes
=======

default
-------
Just a placeholder for now, when we have more shared components they will probably live there.

dd-agent
--------
Installs the Datadog agent on the target system, sets the API key, and start the service to report on the local system metrics

dd-handler
----------
Installs the [chef-handler-datadog](https://rubygems.org/gems/chef-handler-datadog) gem and invokes the handler at the end of a chef run to report the details back to the newsfeed.


Usage
=====

1. Add this cookbook to your Chef Server, either by installing with knife or downloading and uploading to your chef-server with knife.
2. Add your API Key, either to `attributes/default.rb`, or by using the inheritance model and placing it on the node/
3. Upload the new recipe via: `knife cookbook upload datadog`
4. Associate the recipes with the desired `roles`, i.e. "role:chef-client" should contain "datadog::dd-handler" and a "role:somethingelse" should start the dd-agent with "datadog::dd-agent".
4. Wait until chef-client runs on the target node (or trigger chef-client if you're impatient)

We are not making use of data_bags in this recipe at this time, as it is unlikely that you will have more than 1 API key.

Changes/Roadmap
===============
## v0.0.13
* Added redis & memcached
* `dd-agent` - updated to include more platforms
* `dd-handler` - updated to leverage `chef_gem` resource if available
* Updated copyright for 2012
* Updated syntax for node attribute accessors

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

License and Author
==================

Author:: Mike Fiedler (<miketheman@gmail.com>)
Author:: Alexis Le-quoc (<alq@datadoghq.com>)

Copyright 2012, Datadog, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
