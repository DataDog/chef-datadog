# Datadog Chef Cookbook

The Datadog Chef recipes are used to deploy Datadog's components and configuration automatically. The cookbook includes support for:

* Datadog Agent v7.x (default)
* Datadog Agent v6.x
* Datadog Agent v5.x

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

**Chef 12 users**: Depending on your version of Chef 12, additional dependency constraints may apply:

```ruby
# Chef < 12.14
depends 'yum', '< 5.0'
```

```ruby
# Chef < 12.9
depends 'apt', '< 6.0.0'
depends 'yum', '< 5.0'
```

**Chef 13 users**: With Chef 13 and `chef_handler` 1.x, you may have trouble using the `dd-handler` recipe. The known workaround is to update your dependency to `chef_handler` >= 2.1.

**Chef 14 and 15 users**: To support Chef 12 and 13, the `datadog` cookbook has a dependency to the `chef_handler` cookbook, which is shipped as a resource in Chef 14. Unfortunately, it displays a deprecation message to Chef 14 and 15 users.

### Installation

1. Add the cookbook to your Chef server with [Berkshelf][5] or [Knife][6]:
    ```text
    # Berksfile
    cookbook 'datadog', '~> 4.0.0'
    ```

    ```shell
    # Knife
    knife cookbook site install datadog
    ```

2. Set the [Datadog-specific attributes](#datadog-attributes) in a role, environment, or another recipe:
    ```text
    node.default['datadog']['api_key'] = "<YOUR_DD_API_KEY>"

    node.default['datadog']['application_key'] = "<YOUR_DD_APP_KEY>"
    ```

3. Upload the updated cookbook to your Chef server:
    ```shell
    berks upload
    # or
    knife cookbook upload datadog
    ```

4. After uploading, add the cookbook to your node's `run_list` or `role`:
    ```text
    "run_list": [
      "recipe[datadog::dd-agent]"
    ]
    ```

5. Wait for the next scheduled `chef-client` run or trigger it manually.

### Dockerized environment

To build a Docker environment, use the files under `docker_test_env`:

```
cd docker_test_env
docker build -t chef-datadog-container .
```

To run the container use:

```
docker run -d -v /dev/vboxdrv:/dev/vboxdrv --privileged=true chef-datadog-container
```

Then attach a console to the container or use the VScode remote-container feature to develop inside the container.

#### Datadog attributes

The following methods are available for adding your [Datadog API and application keys][4]:

* As node attributes with an `environment` or `role`.
* As node attributes by declaring the keys in another cookbook at a higher precedence level.
* In the node `run_state` by setting `node.run_state['datadog']['api_key']` in another cookbook preceding Datadog's recipes in the `run_list`. This approach does not store the credential in clear text on the Chef Server.

**Note**: When using the run state to store your API and application keys, set them at compile time before `datadog::dd-handler` in the run list.

#### Extra configuration

To add additional elements to the Agent configuration file (typically `datadog.yaml`) that are not directly available as attributes of the cookbook, use the `node['datadog']['extra_config']` attribute. This is a hash attribute, which is marshaled into the configuration file accordingly.

##### Examples

The following code sets the field `secret_backend_command` in the configuration file `datadog.yaml`:

```ruby
 default_attributes(
   'datadog' => {
     'extra_config' => {
       'secret_backend_command' => '/sbin/local-secrets'
     }
   }
 )
```

The `secret_backend_command` can also be set using:

```text
default['datadog']['extra_config']['secret_backend_command'] = '/sbin/local-secrets'
```

For nested attributes, use object syntax. The following code sets the field `logs_config` in the configuration file `datadog.yaml`:

```ruby
default['datadog']['extra_config']['logs_config'] = { 'use_port_443' => true }
```

#### AWS OpsWorks Chef deployment

Follow the steps below to deploy the Datadog Agent with Chef on AWS OpsWorks:

1. Add Chef custom JSON:
  ```json
  {"datadog":{"agent_major_version": 7, "api_key": "<API_KEY>", "application_key": "<APP_KEY>"}}
  ```

2. Include the recipe in the `install-lifecycle` recipe:
  ```ruby
  include_recipe 'datadog::dd-agent'
  ```

### Integrations

Enable Agent integrations by including the [recipe](#recipes) and configuration details in your role’s run-list and attributes.
**Note**: You can create additional integration recipes by using the [datadog_monitor](#datadog-monitor) resource.

Associate your recipes with the desired `roles`, for example `role:chef-client` should contain `datadog::dd-handler` and `role:base` should start the Agent with `datadog::dd-agent`. Below is an example role with the `dd-handler`, `dd-agent`, and `mongo` recipes:

```ruby
name 'example'
description 'Example role using DataDog'

default_attributes(
  'datadog' => {
    'agent_major_version' => 7,
    'api_key' => '<YOUR_DD_API_KEY>',
    'application_key' => '<YOUR_DD_APP_KEY>',
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

**Note**: `data_bags` are not used in this recipe because it is unlikely to have multiple API keys with only one application key.

## Versions

By default, the current major version of this cookbook installs Agent v7. The following attributes are available to control the Agent version installed:

| Parameter              | Description                                                                                                                                                                         |
|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `agent_major_version`  | Pin the major version of the Agent to 5, 6, or 7 (default).                                                                                                                         |
| `agent_version`        | Pin a specific Agent version (recommended).                                                                                                                                         |
| `agent_package_action` | (Linux only) Defaults to `'install'` (recommended), `'upgrade'` to get automatic Agent updates (not recommended, use the default and change the pinned `agent_version` to upgrade). |
| `agent_flavor` | (Linux only) Defaults to `'datadog-agent'` to install the datadog-agent, can be set to `'datadog-iot-agent'` to install the IOT agent. |

See the sample [attributes/default.rb][1] for your cookbook version for all available attributes.

### Upgrade

Some attribute names have changed from version 3.x to 4.x of the cookbook. Use this reference table to update your configuration:

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

Use one of the following methods to upgrade from Agent v6 to v7:

* Set `agent_major_version` to `7`, `agent_package_action` to `install`, and pin a specific v7 version as `agent_version` (recommended).
* Set `agent_major_version` to `7` and `agent_package_action` to `upgrade`.

The following example upgrades from Agent v6 to v7. The same applies if you are upgrading from Agent v5 to v6.

```ruby
default_attributes(
  'datadog' => {
    'agent_major_version' => 7,
    'agent_version' => '7.25.1',
    'agent_package_action' => 'install',
  }
)
```

### Downgrade

To downgrade the Agent version, set the `'agent_major_version'`, `'agent_version'`, and `'agent_allow_downgrade'`.

The following example downgrades to Agent v6. The same applies if you are downgrading to Agent v5.

```ruby
  default_attributes(
    'datadog' => {
      'agent_major_version' => 6,
      'agent_version' => '6.10.0',
      'agent_allow_downgrade' => true
    }
  )
```

## Recipes

Access the [Datadog Chef recipes on GitHub][7].

### Default

The [default recipe][8] is a placeholder.

### Agent

The [dd-agent recipe][9] installs the Datadog Agent on the target system, sets your [Datadog API key][4], and starts the service to report on local system metrics.

**Note**: Windows users upgrading the Agent from versions <= 5.10.1 to >= 5.12.0, set the `windows_agent_use_exe` attribute to `true`. For more details, see the [dd-agent wiki][10].

### Handler

The [dd-handler recipe][11] installs the [chef-handler-datadog][12] gem and invokes the handler at the end of a Chef run to report the details to the newsfeed.

### DogStatsD

To install a language-specific library that interacts with DogStatsD:

- Ruby: [dogstatsd-ruby recipe][13]
- Python: Add a dependency on the `poise-python` cookbook to your custom/wrapper cookbook, and use the resource below. For more details, refer to the [poise-python repository][14].
    ```ruby
    python_package 'dogstatsd-python' # assumes python and pip are installed
    ```

### Tracing

To install a language-specific library for application tracing (APM):

- Ruby: [ddtrace-ruby recipe][15]
- Python: Add a dependency on the `poise-python` cookbook to your custom/wrapper cookbook, and use the resource below. For more details, refer to the [poise-python repository][14].
    ```ruby
    python_package 'ddtrace' # assumes python and pip are installed
    ```

### Integrations

There are many [recipes][7] to assist you with deploying Agent integration configuration files and dependencies.

## Resources

### Integrations without recipes

Use the `datadog_monitor` resource for enabling Agent integrations without a recipe.

#### Actions

- `:add`: (default) Enables the integration by setting up the configuration file, adding the correct permissions to the file, and restarting the Agent.
- `:remove`: Disables an integration.

#### Syntax

```ruby
datadog_monitor 'name' do
  init_config                       Hash # default value: {}
  instances                         Array # default value: []
  logs                              Array # default value: []
  use_integration_template          true, false # default value: false
  action                            Symbol # defaults to :add
end
```

#### Properties

| Property                   | Description                                                                                                                                                                                                                                                                                    |
|----------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `'name'`                   | The name of the Agent integration to configure and enable.                                                                                                                                                                                                                                     |
| `instances`                | The fields used to fill values under the `instances` section in the integration configuration file.                                                                                                                                                                                            |
| `init_config`              | The fields used to fill values under the the `init_config` section in the integration configuration file.                                                                                                                                                                                      |
| `logs`                     | The fields used to fill values under the the `logs` section in the integration configuration file.                                                                                                                                                                                             |
| `use_integration_template` | Set to `true` (recommended) to use the default template, which writes the values of `instances`, `init_config`, and `logs` in the YAML under their respective keys. This defaults to `false` for backward compatibility, but will default to `true` in a future major version of the cookbook. |

#### Example

This example enables the ElasticSearch integration by using the `datadog_monitor` resource. It provides the instance configuration (in this case: the URL to connect to ElasticSearch) and sets the `use_integration_template` flag to use the default configuration template. Also, it notifies the `service[datadog-agent]` resource to restart the Agent.

**Note**: The Agent installation must be above this recipe in the run list.

```ruby
include_recipe 'datadog::dd-agent'

datadog_monitor 'elastic' do
  instances  [{'url' => 'http://localhost:9200'}]
  use_integration_template true
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
```

See the [Datadog integration Chef recipes][7] for additional examples.

### Integration versions

To install a specific version of a Datadog integration, use the `datadog_integration` resource.

#### Actions

- `:install`: (default) Installs an integration with the specified version.
- `:remove`: Removes an integration.

#### Syntax

```ruby
datadog_integration 'name' do
  version                      String         # version to install for :install action
  action                       Symbol         # defaults to :install
  third_party                  [true, false]  # defaults to :false
end
```

#### Properties

- `'name'`: The name of the Agent integration to install, for example: `datadog-apache`.
- `version`: The version of the integration to install (only required with the `:install` action).
- `third_party`: Set to false if installing a Datadog integration, true otherwise. Available for Datadog Agents version 6.21/7.21 and higher only.

#### Example

This example installs version `1.11.0` of the ElasticSearch integration by using the `datadog_integration` resource.

**Note**: The Agent installation must be above this recipe in the run list.

```ruby
include_recipe 'datadog::dd-agent'

datadog_integration 'datadog-elastic' do
  version '1.11.0'
end
```

To get the available versions of the integrations, refer to the integration-specific `CHANGELOG.md` in the [integrations-core repository][16].

**Note**: For Chef Windows users, the `chef-client` must have read access to the `datadog.yaml` file when the `datadog-agent` binary available on the node is used by this resource.


[1]: https://github.com/DataDog/chef-datadog/blob/master/attributes/default.rb
[2]: https://github.com/DataDog/chef-datadog/releases/tag/v2.18.0
[3]: https://github.com/DataDog/chef-datadog/blob/master/CHANGELOG.md
[4]: https://app.datadoghq.com/account/settings#api
[5]: https://docs.chef.io/berkshelf/
[6]: https://docs.chef.io/knife/
[7]: https://github.com/DataDog/chef-datadog/tree/master/recipes
[8]: https://github.com/DataDog/chef-datadog/blob/master/recipes/default.rb
[9]: https://github.com/DataDog/chef-datadog/blob/master/recipes/dd-agent.rb
[10]: https://github.com/DataDog/dd-agent/wiki/Windows-Agent-Installation
[11]: https://github.com/DataDog/chef-datadog/blob/master/recipes/dd-handler.rb
[12]: https://rubygems.org/gems/chef-handler-datadog
[13]: https://github.com/DataDog/chef-datadog/blob/master/recipes/dogstatsd-ruby.rb
[14]: https://github.com/poise/poise-python
[15]: https://github.com/DataDog/chef-datadog/blob/master/recipes/ddtrace-ruby.rb
[16]: https://github.com/DataDog/integrations-core
