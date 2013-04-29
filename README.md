Where to Find the Code
======================
To submit issues and patches please visit https://github.com/DataDog/chef-datadog.
The code is licensed under the Apache License 2.0 (see  LICENSE for details).

[![Build Status](https://secure.travis-ci.org/DataDog/chef-datadog.png?branch=master)](http://travis-ci.org/DataDog/chef-datadog)

Datadog Cookbook
================

Chef recipes to deploy Datadog's components and configuration automatically.

Requirements
============
- python >= 2.6
- chef >= 10.12

Platform
--------

* Debian, Ubuntu, RedHat, CentOS

Cookbooks
---------

The following Opscode cookbooks are dependencies:

* apt
* chef_handler
* yum


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
