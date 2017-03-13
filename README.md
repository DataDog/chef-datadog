Where to Find the Code
======================
To submit issues and patches please visit https://github.com/DataDog/chef-datadog.
The code is licensed under the Apache License 2.0 (see  LICENSE for details).

[![Chef cookbook](https://img.shields.io/cookbook/v/datadog.svg?style=flat)](https://github.com/DataDog/chef-datadog)
[![Build Status](https://travis-ci.org/DataDog/chef-datadog.svg?branch=master)](https://travis-ci.org/DataDog/chef-datadog)
[![Circle CI](https://circleci.com/gh/DataDog/chef-datadog.svg?style=shield)](https://circleci.com/gh/DataDog/chef-datadog)
[![Coverage Status](https://coveralls.io/repos/DataDog/chef-datadog/badge.svg?branch=master)](https://coveralls.io/r/DataDog/chef-datadog?branch=master)
[![GitHub forks](https://img.shields.io/github/forks/DataDog/chef-datadog.svg)](https://github.com/DataDog/chef-datadog/network)
[![GitHub stars](https://img.shields.io/github/stars/DataDog/chef-datadog.svg)](https://github.com/DataDog/chef-datadog/stargazers)
[![Build Status](https://jenkins-01.eastus.cloudapp.azure.com/job/datadog-cookbook/badge/icon)](https://jenkins-01.eastus.cloudapp.azure.com/job/datadog-cookbook/)

Datadog Cookbook
================

Chef recipes to deploy Datadog's components and configuration automatically.

**NB: This README may refer to features that are not released yet. Please check the README of the
git tag/the gem version you're using for your version's documentation**

Requirements
============
- chef >= 10.14

Platforms
---------

* Amazon Linux
* CentOS
* Debian
* RedHat
* Scientific Linux
* Ubuntu
* Windows (requires chef >= 12.0)

Cookbooks
---------

The following Opscode cookbooks are dependencies:

* `apt`
* `chef_handler`
* `windows`
* `yum`

**Note for Chef 11 users**: please use these additional dependency version contraints for compatibility with Chef 11:

```
cookbook 'apt', '< 4.0'
cookbook 'chef_handler', '< 2.0'
cookbook 'windows', '< 2.0'
cookbook 'yum', '~> 3.0'
```

(in Berkshelf/Librarian format)

Recipes
=======

default
-------
Just a placeholder for now, when we have more shared components they will probably live there.

dd-agent
--------
Installs the Datadog agent on the target system, sets the API key, and start the service to report on the local system metrics

**Note for Windows**: With Chef >= 12.6 _and_ the `windows` cookbook >= 1.39.0, Agent upgrades are known to fail.
For Chef>=12.6 users on Windows, we recommend pinning the `windows` cookbook to a lower version (`~> 1.38.0` for instance).
If that's not an option, a known workaround is to use the `remove-dd-agent` recipe (since the `2.5.0` version of the present cookbook) to uninstall the Agent
prior to any Agent upgrade.

dd-handler
----------
Installs the [chef-handler-datadog](https://rubygems.org/gems/chef-handler-datadog) gem and invokes the handler at the end of a Chef run to report the details back to the newsfeed.

dogstatsd-(python|ruby)
-----------------------
Installs the language-specific libraries to interact with `dogstatsd`.

other
-----
There are many other integration-specific recipes, that are meant to assist in deploying the correct agent configuration files and dependencies for a given integration.


Usage
=====

1. Add this cookbook to your Chef Server, either by installing with knife or by adding it to your Berksfile:
  ```
  cookbook 'datadog', '~> 2.7.0'
  ```
2. Add your API Key either:
  * as a node attribute via an `environment` or `role`, or
  * as a node attribute by declaring it in another cookbook at a higher precedence level, or
  * in the node `run_state` by setting `node.run_state['datadog']['api_key']` in another cookbook preceding `datadog`'s recipes in the run_list. This approach has the benefit of not storing the credential in clear text on the Chef Server.
3. Create an 'application key' for `chef_handler` [here](https://app.datadoghq.com/account/settings#api), and add it as a node attribute or in the run state, as in Step #2.

   NB: if you're using the run state to store the api and app keys you need to set them at compile time before `datadog::dd-handler` in the run list.

4. Associate the recipes with the desired `roles`, i.e. "role:chef-client" should contain "datadog::dd-handler" and a "role:base" should start the agent with "datadog::dd-agent".  Here's an example role with both recipes:
  ```
  name 'example'
  description 'Example role using DataDog'

  default_attributes(
    'datadog' => {
      'api_key' => 'api_key',
      'application_key' => 'app_key'
    }
  )

  run_list %w(
    recipe[datadog::dd-agent]
    recipe[datadog::dd-handler]
  )
  ```
5. Wait until `chef-client` runs on the target node (or trigger chef-client manually if you're impatient)

We are not making use of data_bags in this recipe at this time, as it is unlikely that you will have more than one API key and one application key.

For more deployment details, visit the [Datadog Documentation site](http://docs.datadoghq.com/).
