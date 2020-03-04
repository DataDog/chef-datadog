# Datadog Chef Cookbook

The Datadog Chef recipes are used to deploy Datadog's components and configuration automatically. This cookbook includes support for:

* Datadog Agent version 7.x (default)
* Datadog Agent version 6.x
* Datadog Agent version 5.x
* Log collection with Agent v6 & v7 (enable in [default.rb][1])

**Note**: This page may refer to features that are not available for your selected version. Check the README of the
git tag or gem version for your version's documentation.

## Setup

### Requirements

The Datadog Chef cookbook is compatible with `chef-client` >= 12.7. If you need support for Chef < 12.7, use a [release 2.x of the cookbook][2]. See the [CHANGELOG][3] for more info.

#### Platforms

The following platforms are supported:

* Amazon Linux
* CentOS
* Debian
* RedHat (RHEL 8 requires Chef >= 15)
* Scientific Linux
* Ubuntu
* Windows
* SUSE (requires Chef >= 13.3)

#### Cookbooks

The following Opscode cookbooks are dependencies:

* `apt`
* `chef_handler`
* `yum`

**Note**: `apt` cookbook v7.1+ is needed to install the Agent on Debian 9+.

#### Chef

**Chef 12 users**: Depending on your version of Chef 12, there may be additional dependency constraints:

```ruby
# Chef < 12.14
depends 'yum', '< 5.0'
```

```ruby
# Chef < 12.9
depends 'apt', '< 6.0.0'
depends 'yum', '< 5.0'
```

**Chef 13 users**: For Chef 13 and `chef_handler` 1.x, you may have trouble using the dd-handler recipe. The known workaround is to update your dependency to `chef_handler` >= 2.1.

**Chef 14 and 15 users**: To support Chef 12 and 13, the `datadog` cookbook has a dependency to the `chef_handler` cookbook, which is shipped as a resource in Chef 14. Unfortunately, it displays a deprecation message to Chef 14 and 15 users.

### Installation

1. Add the cookbook to your Chef Server, either by installing with knife or by adding it to your Berksfile:
    ```
    cookbook 'datadog', '~> 4.0.0'
    ```
2. Choose a method to add your [Datadog API Key][4]:
  * As a node attribute with an `environment` or `role`.
  * As a node attribute by declaring it in another cookbook at a higher precedence level.
  * In the node `run_state` by setting `node.run_state['datadog']['api_key']` in another cookbook preceding Datadog's recipes in the run_list. This approach does not store the credential in clear text on the Chef Server.

3. Create an 'application key' for `chef_handler` [here](https://app.datadoghq.com/account/settings#api), and add it as a node attribute or in the run state, as in Step #2.

    NB: if you're using the run state to store the api and app keys you need to set them at compile time before `datadog::dd-handler` in the run list.

4. Enable Agent integrations by including their recipes and configuration details in your role’s run-list and attributes.
   Note that you can also create additional integrations recipes by using the `datadog_monitor` resource.

5. Associate the recipes with the desired `roles`, i.e. "role:chef-client" should contain "datadog::dd-handler" and a "role:base" should start the agent with "datadog::dd-agent". Here's an example role with both recipes plus the MongoDB integration enabled.
    ```ruby
    name 'example'
    description 'Example role using DataDog'

    default_attributes(
      'datadog' => {
        'agent_major_version' => 7,
        'api_key' => 'api_key',
        'application_key' => 'app_key',
        'mongo' => {
          'instances' => [
            {'host' => 'localhost', 'port' => '27017'}
          ]
        }
      }
    )

    run_list %w(
      recipe[datadog::dd-agent]
      recipe[datadog::dd-handler]
      recipe[datadog::mongo]
    )
    ```

6. Wait until `chef-client` runs on the target node (or trigger chef-client manually if you're impatient)

**Note**: `data_bags` are not used in this recipe because it is unlikely to have more than one API key with only one application key.

#### AWS OpsWorks Chef deployment

1. Add Chef Custom JSON:
  ```json
  {"datadog":{"agent_major_version": 7, "api_key": "<API_KEY>", "application_key": "<APP_KEY>"}}
  ```

2. Include the recipe in install-lifecycle recipe:
  ```ruby
  include_recipe 'datadog::dd-agent'
  ```

### Upgrading

Upgrading to version 4.x of the cookbook

Some attributes have changed their names from version 3.x to 4.x of this cookbook. Use this reference table to update your configuration:

| Action                | Cookbook 3.x                                          | Cookbook 4.x                              |
|-----------------------|-------------------------------------------------------|-------------------------------------------|
| Install Agent 7.x     | Not supported                                         | `'agent_major_version' => 7`              |
| Install Agent 6.x     | `'agent6' => true`                                    | `'agent_major_version' => 6`              |
| Install Agent 5.x     | `'agent6' => false`                                   | `'agent_major_version' => 5`              |
| Pin agent version     | `'agent_version'` or `'agent6_version'`               | `'agent_version'` for all versions        |
| Change package_action | `'agent_package_action'` or `'agent6_package_action'` | `'agent_package_action'` for all versions |
| Change APT repo URL   | `'aptrepo'` or `'agent6_aptrepo'`                     | `'aptrepo'` for all versions              |
| Change APT repo dist  | `'aptrepo_dist'` or `'agent6_aptrepo_dist'`           | `'aptrepo_dist'` for all versions         |
| Change YUM repo       | `'yumrepo'` or `'agent6_yumrepo'`                     | `'yumrepo'` for all versions              |
| Change SUSE repo      | `'yumrepo_suse'` or `'agent6_yumrepo_suse'`           | `'yumrepo_suse'` for all versions         |

#### Example

If you had an Agent 6 installation, the same configuration will now look like this:

```ruby
default_attributes(
  'datadog' => {
    'agent_major_version' => 6,          # was 'agent6' => true,
    'agent_version' => '6.10.0',         # was 'agent6_version' => '6.10.0',
    'agent_package_action' => 'install', # was 'agent6_package_action' => 'install',
  }
)
```

## Usage

By default, the current major version (4.x) of this cookbook installs Agent v7.

Attributes are available to have finer control over which version of the Agent you install:

 * `agent_major_version`: allows you to pin the major version of the agent to 5, 6 or 7 (default).
 * `agent_version`: allows you to pin a specific agent version (recommended).
 * `agent_package_action` (Linux only): Defaults to `'install'`, can be set `'upgrade'` to get automatic agent updates (we recommend you keep the default here and instead change the pinned `agent_version` to upgrade).

Please review the [attributes/default.rb](https://github.com/DataDog/chef-datadog/blob/master/attributes/default.rb) file (at the version of the cookbook you use) for the full list and usage of the attributes used by the cookbook.

For general information on the Datadog Agent, please refer to the [datadog-agent](https://github.com/DataDog/datadog-agent/) repo.

#### Extra configuration

Should you wish to add additional elements to the Agent v6 configuration file
(typically `datadog.yaml`) that are not directly available
as attributes of the cookbook, you may use the `node['datadog']['extra_config']`
attribute. This attribute is a hash and will be marshaled into the configuration
file accordingly.

E.g.

```ruby
 default_attributes(
   'datadog' => {
     'extra_config' => {
       'secret_backend_command' => '/sbin/local-secrets'
     }
   }
 )
```
or
```
default['datadog']['extra_config']['secret_backend_command'] = '/sbin/local-secrets'
```

This example will set the field `secret_backend_command` in the configuration
file `datadog.yaml`.

For nested attributes, use object syntax:

E.g.

```ruby
default['datadog']['extra_config']['logs_config'] = { 'use_port_443' => true }
```

This example will set the field `logs_config` in the configuration file `datadog.yaml`.

### Using Agent v6 or v5

You can still setup the Agent v6 by setting `node['datadog']['agent_major_version']` to 6.

Note that `agent_major_version` and `agent_version` should be kept consistent.

```ruby
  default_attributes(
    'datadog' => {
      'agent_major_version' => 6
    }
  )
```

The same works for version 5.

### Agent v5 transitions

#### Upgrade from Agent v6 to Agent v7

To upgrade from an already installed Agent v6 to Agent v7, you'll have to either:

* Set `agent_major_version` to `7`, `agent_package_action` to `install` and pin a specific v7 version as `agent_version` (recommended).
* Set `agent_major_version` to `7` and `agent_package_action` to `upgrade`.

```ruby
  default_attributes(
    'datadog' => {
      'agent_major_version' => 7,
      'agent_version' => '7.15.0',
      'agent_package_action' => 'install',
    }
  )
```

The same applies if upgrading from 5 to 6.

#### Downgrade from an installed Agent v7 to an Agent v6

You will need to indicate that you want to setup an Agent v6 instead of v7, pin the Agent v6 version that you want to install and allow downgrade:

```ruby
  default_attributes(
    'datadog' => {
      'agent_major_version' => 6,
      'agent_version' => '6.10.0',
      'agent_allow_downgrade' => true
    }
  )
```

The same works for version 5.

## Recipes

### default

Just a placeholder for now, when we have more shared components they will probably live there.

### dd-agent

Installs the Datadog agent on the target system, sets the API key, and start the service to report on the local system metrics

**Notes for Windows**:

* Because of changes in the Windows Agent packaging and install in version 5.12.0, when upgrading the Agent from versions <= 5.10.1 to versions >= 5.12.0,
  please set the `windows_agent_use_exe` attribute to `true`.

  Once the upgrade is complete, you can leave the attribute to its default value (`false`).

  For more information on these Windows packaging changes, see the related [docs on the dd-agent wiki](https://github.com/DataDog/dd-agent/wiki/Windows-Agent-Installation).

### dd-handler

Installs the [chef-handler-datadog](https://rubygems.org/gems/chef-handler-datadog) gem and invokes the handler at the end of a Chef run to report the details back to the newsfeed.

### dogstatsd-ruby

Installs the language-specific libraries to interact with `dogstatsd`.

For ruby, please use the `datadog::dogstatsd-ruby` recipe.

For Python, please add a dependency on the `poise-python` cookbook to your custom/wrapper cookbook, and use the following resource:
  ```ruby
  python_package 'dogstatsd-python' # assumes that python and pip are installed
  ```
  For more advanced usage, please refer to the [`poise-python` cookbook documentation](https://github.com/poise/poise-python)

### ddtrace-ruby

Installs the language-specific libraries for application Traces (APM).

For ruby, please use the `datadog::ddtrace-ruby` recipe.

For Python, please add a dependency on the `poise-python` cookbook to your custom/wrapper cookbook, and use the following resource:
  ```ruby
  python_package 'ddtrace' # assumes that python and pip are installed
  ```
  For more advanced usage, please refer to the [`poise-python` cookbook documentation](https://github.com/poise/poise-python)

### other

There are many other integration-specific recipes, that are meant to assist in deploying the correct agent configuration files and dependencies for a given integration.

## Resources

### datadog_monitor

The `datadog_monitor` resource will help you to enable Agent integrations.

The default action `:add` enables the integration by filling a configuration file for the integration with the values provided to the resource, setting the correct permissions on that file, and restarting the Agent.

The `:remove` action disables an integration.

#### Syntax

```ruby
datadog_monitor 'name' do
  init_config                       Hash # default value: {}
  instances                         Array # default value: []
  logs                              Array # default value: []
  use_integration_template          true, false # default value: false
  action                            Symbol # defaults to :add if not specified
end
```

#### Actions

* `:add` Default. Enable the integration.
* `:remove` Use this action to disable the integration.

#### Properties

* `'name'` is the name of the Agent integration to configure and enable
* `instances` are the fields used to fill values under the `instances` section in the integration configuration file.
* `init_config` are the fields used to fill values under the the `init_config` section in the integration configuration file.
* `logs` are the fields used to fill values under the the `logs` section in the integration configuration file.
* `use_integration_template`: set to `true` (recommended) to use a default template that simply writes the values of `instances`, `init_config`and `logs` in YAML under their respective YAML keys. (defaults to `false` for backward compatibility, will default to `true` in a future major version of the cookbook)

#### Example

This example enables the ElasticSearch integration by using the `datadog_monitor` resource. It provides the instance configuration (in this case: the url to connect to ElasticSearch) and sets the `use_integration_template` flag to use the default configuration template. Also, it notifies the `service[datadog-agent]` resource in order to restart the Agent.

Note that the Agent installation needs to be earlier in the run list.

```ruby
include_recipe 'datadog::dd-agent'

datadog_monitor 'elastic'
  instances  [{'url' => 'http://localhost:9200'}]
  use_integration_template true
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
```

See `recipes/` for many examples using the `datadog_monitor` resource.

### datadog_integration

The `datadog_integration` resource will help you to install specific versions
of Datadog integrations.

The default action `:install` installs the integration on the node using the
`agent integration install` command.

The `:remove` action removes an integration from the node using the `agent
integration remove` command.

#### Syntax

```ruby
datadog_integration 'name' do
  version                           String # version to install for :install action.
  action                            Symbol # defaults to :install if not specified
end
```

#### Actions

* `:install` Default. Installs an integration in the given version.
* `:remove` Removes an integration.

#### Properties

* `'name'` is the name of the Agent integration to install, e.g. `datadog-apache`
* `version` is the version of the integration that you want to install. Only needed
with the `:install` action.

#### Example

This example installs version `1.11.0` of the ElasticSearch integration by
using the `datadog_integration` resource.

Note that the Agent installation needs to be earlier in the run list.

```ruby
include_recipe 'datadog::dd-agent'

datadog_integration 'datadog-elastic'
  version '1.11.0'
end
```

In order to get the available versions of the integrations, please refer to
their `CHANGELOG.md` file in the [integrations-core repository](https://github.com/DataDog/integrations-core).

**Note for Chef Windows users**: as the datadog-agent binary available on the
node is used by this resource, the chef-client must have read access to the
`datadog.yaml` file.


[1]: https://github.com/DataDog/chef-datadog/blob/master/attributes/default.rb
[2]: https://github.com/DataDog/chef-datadog/releases/tag/v2.18.0
[3]: https://github.com/DataDog/chef-datadog/blob/master/CHANGELOG.md
[4]: https://app.datadoghq.com/account/settings#api
