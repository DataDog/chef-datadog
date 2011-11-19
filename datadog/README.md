Datadog Cookbook
================

Chef recipes to deploy Datadog's components automatically.

Requirements
============
- python >= 2.6
- chef >= 0.9

Platform
--------

* Debian, Ubuntu

Cookbooks
---------

The following Opscode cookbooks are dependencies:

* apt
& chef_handler
* yum


Attributes
==========

* `node[:datadog][:api_key]` = This needs to be retrieved from your Account Settings page.
* `node[:datadog][:application_key]` = There are none by default. Visit the Account Settings page to create a new APplication Key, to be used in conjunction with your API key.

* `node[:datadog][:url]` = The location of where Datadog is hosted. Should never change.
* `node[:datadog][:repo]` = Where the Datadog-maintained packages are located. Should never change.


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
Installs the `chef-handler-datadog` gem and invokes the handler at the end of a chef run to report the details back to the newsfeed.


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

## Future
* `dd-agent` - Add support for RPM installs - Red Hat, CentOS, Scientific, Fedora

## v.1.0.2
* Initial refactoring, including the `dd-agent` cookbook here
* Adding chef-handler-datadog to report to the newsfeed

License and Author
==================

Author:: Mike Fiedler (<miketheman@gmail.com>)

Copyright 2011, Datadog, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.