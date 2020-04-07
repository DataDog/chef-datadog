# Contributing

The code is licensed under the Apache License 2.0 (see  LICENSE for details).

[![Chef cookbook](https://img.shields.io/cookbook/v/datadog.svg?style=flat)](https://github.com/DataDog/chef-datadog)
[![Build Status](https://img.shields.io/circleci/build/gh/DataDog/chef-datadog.svg)](https://circleci.com/gh/DataDog/chef-datadog)
[![GitHub forks](https://img.shields.io/github/forks/DataDog/chef-datadog.svg)](https://github.com/DataDog/chef-datadog/network)
[![GitHub stars](https://img.shields.io/github/stars/DataDog/chef-datadog.svg)](https://github.com/DataDog/chef-datadog/stargazers)

First of all, thanks for contributing!

This document provides guidelines and instructions for contributing to this repository. To propose improvements, feel free to submit a PR.

## Submitting issues

* If you think you've found an issue, search the issue list to see if there's an existing issue.
* Then, if you find nothing, open a Github issue.

## Pull Requests

Have you fixed a bug or written a new feature and want to share it? Many thanks!

When submitting your PR, here are some items you can check or improve to facilitate the review process:

  * Have a proper commit history (we advise you to rebase if needed).
  * Write tests for the code you wrote.
  * Preferably, make sure that all unit tests pass locally and some relevant kitchen tests.
  * Summarize your PR with an explanatory title and a message describing your changes, cross-referencing any related bugs/PRs.
  * Open your PR against the `master` branch.

Your pull request must pass all CI tests before we merge it. If you see an error and don't think it's your fault, it may not be! [Join us on Slack][slack] or send us an email, and together we'll get it sorted out.

### Keep it small, focused

Avoid changing too many things at once. For instance if you're fixing a recipe and at the same time adding some code refactor, it makes reviewing harder and the _time-to-release_ longer.

### Commit messages

Please don't be this person: `git commit -m "Fixed stuff"`. Take a moment to write meaningful commit messages.

The commit message should describe the reason for the change and give extra details that allows someone later on to understand in 5 seconds the thing you've been working on for a day.

If your commit is only shipping documentation changes or example files, and is a complete no-op for the test suite, add **[skip ci]** in the commit message body to skip the build and give that slot to someone else who does need it.

### Squash your commits

Rebase your changes on `master` and squash your commits whenever possible. This keeps history cleaner and easier to revert things. It also makes developers happier!

## Development

To contribute, follow the contributing guidelines above.

### Dependencies

First, use [Bundler][bundler] and the provided Gemfile to install the development and release dependencies.

After installing bundler, run the following command to install gem in a vendored folder:

```bash
bundle install --path .bundle
```

### Testing

TDD is the recommended approach for developing in this repo. The project uses [RSpec][rspec] as a unit tests engine. It uses the related `chefspec` gem to abstract the Chef logic. Some Chef specs can fail if you don't use the right version of Chef so be careful to use the one pinned in the Gemfile. To run unit tests, use:

```bash
bundle exec rspec
```

### Integration testing

This project uses [Kitchen][kitchen] as an integration tests engine. To verify integration tests, install [Vagrant][vagrant] on your machine.

Kitchen allows you to test specific recipes described in [kitchen.yml](./kitchen.yml) across all platforms and versions that are also described in the same file. Each combination of recipe x platform x version is a test target.

To list available targets, use the `list` command:

```bash
bundle exec kitchen list
```

To test a specific target, run:

```bash
bundle exec kitchen test <target>
```

For example, to test the CouchDB monitor on Ubuntu 16.04, run:

```bash
bundle exec kitchen test datadog-couchdb-ubuntu-1604-15
```

There is a CouchDB recipe described in the `kitchen.yml`, and an Ubuntu platform with the 16.04 version.

### Development loop

The simplest way to develop fixes or features is to set up the platform and version of your choice with the `create` command and apply the recipe with the `converge` command. To explore the machine and test different things, login with the `login` command.

**Note**: The `login` command only works on Linux and OSX. For Windows, connect to the VM through the Virtual Box interface or with putty or a similar ssh client.

**Note**: The credentials of the created virtual machines are login `vagrant`, password `vagrant`.

```bash
# Create the relevant Vagrant virtual machine
bundle exec kitchen create datadog-couchdb-ubuntu-1604-15

# Converge to test your recipe
bundle exec kitchen converge datadog-couchdb-ubuntu-1604-15

# Login to your machine
bundle exec kitchen login datadog-couchdb-ubuntu-1604-15

# Verify the integration tests for your machine
bundle exec kitchen verify datadog-couchdb-ubuntu-1604-15

# Clean your machine
bundle exec kitchen destroy datadog-couchdb-ubuntu-1604-15
```


[bundler]: https://bundler.io
[kitchen]: https://github.com/test-kitchen/test-kitchen
[rspec]: https://rspec.info/
[slack]: http://datadoghq.slack.com
[vagrant]: https://www.vagrantup.com/
