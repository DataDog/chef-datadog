#
# Cookbook:: datadog
# Attributes:: default
#
# Copyright:: 2011-2015, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Place your API Key here, or set it on the role/environment/node, or set it on your
# node `run_state` under the key `['datadog']['api_key']`.
# The Datadog api key to associate your agent's data with your organization.
# Can be found here:
# https://app.datadoghq.com/account/settings
default['datadog']['api_key'] = nil

# Create an application key on the Account Settings page.
# Set it as an attribute, or on your node `run_state` under the key `['datadog']['application_key']`
default['datadog']['application_key'] = nil

# Agent major version
default['datadog']['agent_major_version'] = nil # nil to autodetect based on 'agent_version'

# Agent Version
# Default of `nil` will install latest version. On Windows, this will also upgrade to latest.
# This attribute takes a `string` with a version number. For compatibiliy reasons it can also take a
# hash with the platform_name as key and the version as value.
# Starting with version 4.1.0, you no longer need to pass the "1:" prefix and "-1" suffix in versions
# for Debian-based and SUSE.
# Example:
# default['datadog']['agent_version'] = '7.16.0'
default['datadog']['agent_version'] = nil # nil to install latest
# Agent flavor to install, acceptable values are "datadog-agent", "datadog-iot-agent"
default['datadog']['agent_flavor'] = 'datadog-agent' # "datadog-agent" to install the datadog-agent package

# Allow override with `upgrade` to get latest (Linux only)
default['datadog']['agent_package_action'] = 'install'

# Agent package options
# retries and retry_delay for package download/install
default['datadog']['agent_package_retries'] = nil
default['datadog']['agent_package_retry_delay'] = nil

# Allow downgrades of the agent (Linux only)
# Note: on apt-based platforms, this will use the `--force-yes` option on the apt-get command. Use with caution.
default['datadog']['agent_allow_downgrade'] = false

########################################################################
###                 Agent 6/7 only attributes                        ###

# The site of the Datadog intake to send Agent data to.
# This configuration option is supported since Agent 6.6
# Defaults to 'datadoghq.com', can be set to 'datadoghq.eu' (for the EU site) or 'us3.datadoghq.com'.
default['datadog']['site'] = nil

# The port on which the IPC api listens
# cmd_port: 5001
default['datadog']['cmd_port'] = nil

# The port for the browser GUI to be served
# Setting 'GUI_port: -1' turns off the GUI completely
# Default is '5002' on Windows and macOS ; turned off on Linux
# GUI_port: -1
default['datadog']['gui_port'] = nil

###                 End of Agent 6/7 only attributes                 ###
########################################################################

# Use this attribute to send data to additional accounts
# (agent and handler if enabled)
# The key can be anything you want, 'prod' is used there as an example
default['datadog']['extra_endpoints']['prod']['enabled'] = nil
default['datadog']['extra_endpoints']['prod']['api_key'] = nil
default['datadog']['extra_endpoints']['prod']['application_key'] = nil
default['datadog']['extra_endpoints']['prod']['url'] = nil # optional

# Add this prefix to all Chef tags sent to Datadog: "#{tag_prefix}#{tag}"
# This makes it easy to group hosts in Datadog by their Chef tags, but might be counterproductive
# if your Chef tags are already in the "#{tag_group}:#{value}" form.
# Set prefix to '' if you want Chef tags to be sent without prefix.
default['datadog']['tag_prefix'] = 'tag:'

# The host of the Datadog intake server to send Agent data to, only set this option
# if you need the Agent to send data to a custom URL.
# The nil value will let the Agent 6/7 select the URL to send the data.
# Any non-nil value overrides the 'site' value, prefer using 'site' unless your
# use case isn't covered by 'site'.
# For Agent 5, the Agent 5 recipe will fallback on https://app.datadoghq.com
# (see recipes/dd-agent.rb).
default['datadog']['url'] = nil

# Add tags as override attributes in your role
# This can be a string of comma separated tags, a hash in this format:
# default['datadog']['tags'] = { 'datacenter' => 'us-east' }
# or an array in this format:
# default['datadog']['tags'] = ['datacenter:us-east']
# Examples above output a string: 'datacenter:us-east'
# When using the Datadog Chef Handler, tags are set on the node with preset prefixes:
# `env:node.chef_environment`, `role:node.node.run_list.role`, `tag:somecheftag`
default['datadog']['tags'] = ''

# The environment name where the agent is running. Attached in-app to every
# metric, event, log, trace, and service check emitted by the Agent.
default['datadog']['env'] = nil

# Collect EC2 tags, set to 'yes' to collect
default['datadog']['collect_ec2_tags'] = nil

# Set this regex to exclude some Chef node tags from the host tags that the datadog handler sends to Datadog
# https://github.com/DataDog/chef-handler-datadog/issues/85
# This means that all the metrics and service checks coming from the
#  host/Agent would also stop being tagged with these excluded tags.
# EX: 'app_.*' allows all tags except those which look like app_.*
default['datadog']['tags_blacklist_regex'] = nil

# Set to `true` if you want the handler to send the Chef policy name and group as host tags
default['datadog']['send_policy_tags'] = false

# Set to an integer if you want the handler to retry submitting tags if the host isn't yet present
# on Datadog. The handler will retry evey 2 seconds until this number of retries is reached or the tags are
# submitted successfully.
default['datadog']['tags_submission_retries'] = nil

# Additional handler config options
# If the Chef Datadog handler supports a config option that's not available directly in this cookbook
# you can set it as a key/value of this hash attribute. `nil` values will be ignored.
default['datadog']['handler_extra_config'] = {}

# repos where datadog-agent packages are available
# If you're installing a pre-release version of the Agent (beta or RC), you need to:
# * on debian: set node['datadog']['aptrepo_dist'] to 'beta' instead of 'stable'
# * on RHEL: set node['datadog']['yumrepo'] to 'https://yum.datadoghq.com/beta/x86_64/'
default['datadog']['aptrepo'] = 'http://apt.datadoghq.com'
default['datadog']['aptrepo_dist'] = 'stable'
default['datadog']['yumrepo'] = nil # uses Datadog stable repos by default
default['datadog']['yumrepo_suse'] = nil # uses Datadog stable repos by default

# Older versions of yum embed M2Crypto with SSL that doesn't support TLS1.2
yum_protocol =
  if platform_family?('rhel') && node['platform_version'].to_i < 6
    'http'
  else
    'https'
  end

# NB: if you're not using the default repos and/or distributions, make sure
# to pin the version you're installing with node['datadog']['agent_version']
default['datadog']['installrepo'] = true
default['datadog']['aptrepo_retries'] = 4
default['datadog']['aptrepo_use_backup_keyserver'] = false
default['datadog']['aptrepo_keyserver'] = 'hkp://keyserver.ubuntu.com:80'
default['datadog']['aptrepo_backup_keyserver'] = 'hkp://pool.sks-keyservers.net:80'
# When repo_gpgcheck set to nil, it will get turned on in the code when
# not running on RHEL/CentOS <= 5 and not providing custom yumrepo.
# You can set it to true/false explicitly to override this behaviour.
default['datadog']['yumrepo_repo_gpgcheck'] = nil
default['datadog']['yumrepo_gpgkey'] = "#{yum_protocol}://keys.datadoghq.com/DATADOG_RPM_KEY.public"
default['datadog']['yumrepo_proxy'] = nil
default['datadog']['yumrepo_proxy_username'] = nil
default['datadog']['yumrepo_proxy_password'] = nil
default['datadog']['windows_agent_url'] = 'https://s3.amazonaws.com/ddagent-windows-stable/'

# This attribute is unsupported and liable to change in patch or minor releases
# The vast majority of use cases will never require you to set this attribute
# Only applies if specific version specified
default['datadog']['windows_agent_installer_prefix'] = nil

# Location of additional rpm gpg keys to import. In the future the rpm packages
# of the Agent will be signed with this key.
# DATADOG_RPM_KEY_CURRENT always contains the key that is used to sign repodata and latest packages
default['datadog']['yumrepo_gpgkey_new_current'] = "#{yum_protocol}://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public"
default['datadog']['yumrepo_gpgkey_new_e09422b3'] = "#{yum_protocol}://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public"
default['datadog']['yumrepo_gpgkey_new_fd4bf915'] = "#{yum_protocol}://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public"

# Windows Agent Blacklist
# Attribute to enforce silent failures on agent installs when attempting to install a
# blacklisted MSI. This attribute is to provide a workaround for users already pinned
# to a blacklisted windows Agent version who may need to avoid breaking their chef runs.
# The new blacklisting logic, by default will fail your chef run.
# Please note that this attribute is no silver bullet, not all failed chef runs due to
# the blacklist will be resolved enabling this feature.
default['datadog']['windows_blacklist_silent_fail'] = false

# Attribute to specify timeout in seconds on MSI operations (install/uninstall)
# Default should suffice, but provides a knob in case instances with limited resources timeout.
default['datadog']['windows_msi_timeout'] = 1200

# Mute hosts during an MSI installation
# To prevent no-data alerts when MSI installs take long.
# Requires setting 'application_key' to a valid app key for the Datadog REST API.
default['datadog']['windows_mute_hosts_during_install'] = false

# Agent installer checksum
# Expected checksum to validate correct agent installer is downloaded (Windows only)
default['datadog']['windows_agent_checksum'] = nil

# Set to `true` to use the EXE installer on Windows, recommended to gracefully handle upgrades from per-user
# to per-machine installs on most environments. We recommend setting this option to `true` for Agent upgrades from
# versions <= 5.10.1 to versions >= 5.12.0.
# The EXE installer exists since Agent release 5.12.0. It is not provided for >= 6.0.0 versions.
# If you're already using version >= 5.12.0 of the Agent, leave this to false.
default['datadog']['windows_agent_use_exe'] = false

# Since 6.11.0, the Datadog Agent creates/uses a custom user to run on Windows.
# Set `windows_ddagentuser_name` using the format `<domain>\<user>` to provide a
# specific username and `windows_ddagentuser_password` to provide a specific password.
# You can set these 2 values as node attributes or on `node.run_state` under
# the keys `['datadog']['windows_ddagentuser_name']` and `['datadog']['windows_ddagentuser_password']`
default['datadog']['windows_ddagentuser_name'] = nil
default['datadog']['windows_ddagentuser_password'] = nil

# Since 7.27, the MSI has a switch to install NPM driver. Default to not install. Specify "true" to install.
default['datadog']['windows_npm_install'] = nil

# Chef handler version
default['datadog']['chef_handler_version'] = nil

# Enable the Chef handler to report to datadog
default['datadog']['chef_handler_enable'] = true

# Log level. Should be a valid python log level https://docs.python.org/2/library/logging.html#logging-levels
default['datadog']['log_level'] = 'INFO'

# Set to true to allow non local traffic to Dogstatsd and the trace agent (and, in Agent 5, to the Forwarder)
default['datadog']['non_local_traffic'] = false

# The loopback address Dogstatsd will bind (in Agent 5, the Forwarder also uses this address)
default['datadog']['bind_host'] = 'localhost'

# Specify agent hostname
# More information available here: http://docs.datadoghq.com/hostnames/#agent
default['datadog']['hostname'] = node.name

# If running on ec2, if true, use the instance-id as the host identifier
# rather than the hostname for chef-handler.
default['datadog']['use_ec2_instance_id'] = false

# Enable the agent to start at boot. Note that this can't be false if 'enable_process_agent'
# or 'enable_trace_agent' are true, since they depend on the main agent.
default['datadog']['agent_enable'] = true

# Start agent or not
default['datadog']['agent_start'] = true

# installation info
default['datadog']['install_info_enabled'] = true

# Logging configuration
default['datadog']['syslog']['active'] = false
default['datadog']['syslog']['udp'] = false
default['datadog']['syslog']['host'] = nil
default['datadog']['syslog']['port'] = nil
default['datadog']['log_to_console'] = nil
default['datadog']['log_file_directory'] =
  if platform_family?('windows')
    nil # let the agent use a default log file dir
  else
    '/var/log/datadog'
  end

# Web proxy configuration
default['datadog']['web_proxy']['host'] = nil
default['datadog']['web_proxy']['port'] = nil
default['datadog']['web_proxy']['user'] = nil
default['datadog']['web_proxy']['password'] = nil
default['datadog']['web_proxy']['skip_ssl_validation'] = nil # accepted values true or false
default['datadog']['web_proxy']['no_proxy'] = nil # only used for agent v6.0+

# dogstatsd
default['datadog']['dogstatsd'] = true
default['datadog']['dogstatsd_port'] = 8125
default['datadog']['dogstatsd_interval'] = 10 # Agent v5 only.
default['datadog']['dogstatsd_normalize'] = 'yes' # Agent v5 only.
default['datadog']['dogstatsd_target'] = 'http://localhost:17123' # Agent v5 only.
default['datadog']['statsd_forward_host'] = nil
default['datadog']['statsd_forward_port'] = 8125
default['datadog']['statsd_metric_namespace'] = nil

# Histogram settings
default['datadog']['histogram_aggregates'] = 'max, median, avg, count'
default['datadog']['histogram_percentiles'] = '0.95'

# extra config options
# If an agent is released with a new config option which is not yet supported by this cookbook
# you can use this attribute to set it. Will be ignored if nil.
default['datadog']['extra_config']['forwarder_timeout'] = nil

# extra_packages to install
default['datadog']['extra_packages'] = {}

# For service-specific configuration, use the integration recipes included
# in this cookbook, and apply them to the appropirate node's run list.
# Read more at http://docs.datadoghq.com/

# Service discovery settings
# Enable with service_discovery_backend ('docker' is only valid option currently)
default['datadog']['sd_backend_host'] = '127.0.0.1'
default['datadog']['sd_backend_port'] = 4001
default['datadog']['sd_config_backend'] = 'etcd'
default['datadog']['sd_template_dir'] = '/datadog/check_configs'
default['datadog']['sd_jmx_enable'] = 'no'
default['datadog']['service_discovery_backend'] = nil

# Trace functionality settings
# Set `enable_trace_agent` to:
# * `true` to explicitly enable the trace agent
# * `false` to explicitly disable it
# Leave it to `nil` to let the agent's default behavior decide whether to run the trace-agent
default['datadog']['enable_trace_agent'] = nil
default['datadog']['trace_env'] = nil
default['datadog']['extra_sample_rate'] = nil
default['datadog']['max_traces_per_second'] = nil
default['datadog']['receiver_port'] = nil
# `connection_limit` is ignored in Agent 6/7
default['datadog']['connection_limit'] = nil

# ddtrace ruby gem version
default['datadog']['ddtrace_gem_version'] = nil

# Live processes functionality settings
# Set `enable_process_agent` to:
# * `true` to explicitly enable the process agent
# * `false` to explicitly disable it
# Leave it to `nil` to let the agent's default behavior decide whether to run the process-agent
default['datadog']['enable_process_agent'] = nil
default['datadog']['process_agent']['url'] = 'https://process.datadoghq.com'

# A list of regex patterns matching process commands to blacklist.
# Example: ['my-secret-app', 'dbpass']
default['datadog']['process_agent']['blacklist'] = []

# Controls the behavior of the cmdline data scrubber
# If enabled, hides every cmdline argument value whose key matches one of the default
# or custom sensitive words
# Default sensitive words: ['password', 'passwd', 'mysql_pwd', 'access_token', 'auth_token',
# 'api_key', 'apikey', 'secret', 'credentials', 'stripetoken']
default['datadog']['process_agent']['scrub_args'] = true
# Example for custom sensitive words: ['consul_token', 'token', 'dd_api_key']
default['datadog']['process_agent']['custom_sensitive_words'] = []

# Full path to store process-agent logs to override the default.
default['datadog']['process_agent']['log_file'] = nil

# If running in full process collection mode ('enable_process_agent' is true)
# overrides the collection intervals for the full and real-time checks in seconds.
default['datadog']['process_agent']['process_interval'] = nil
default['datadog']['process_agent']['rtprocess_interval'] = nil

# If only collecting containers ('enable_process_agent' is false but docker is available)
# overrides the collection intervals for the full and real-time check.
default['datadog']['process_agent']['container_interval'] = nil
default['datadog']['process_agent']['rtcontainer_interval'] = nil

# System probe functionality settings

# Whether this cookbook should write system-probe.yaml or not.
# If set to false all other system-probe settings are ignored
default['datadog']['system_probe']['manage_config'] = true
default['datadog']['system_probe']['enabled'] = false
# sysprobe_socket defines the unix socket location
default['datadog']['system_probe']['sysprobe_socket'] = '/opt/datadog-agent/run/sysprobe.sock'
# debug_port is the http port for expvar, it is disabled if set to 0
default['datadog']['system_probe']['debug_port'] = 0
default['datadog']['system_probe']['bpf_debug'] = false
default['datadog']['system_probe']['enable_conntrack'] = false
# Enable this switch will install NPM driver and sysprobe, as well as generate the config file.
# Turning on this setting will effectively turn on the setting(s) automatically:
# ['datadog']['system_probe']['enabled']
default['datadog']['system_probe']['network_enabled'] = false

# Logs functionality settings (Agent 6/7 only)
# Set `enable_logs_agent` to:
# * `true` to explicitly enable the log agent
# * `false` to explicitly disable it
# Leave it to `nil` to let the agent's default behavior decide whether to run the log-agent
default['datadog']['enable_logs_agent'] = nil
# Here you can specify any settings that should end up under 'logs_config' in datadog.yaml
# eg: default['datadog']['logs_agent_config'] = { 'use_http' => false, 'use_compression' => true }
default['datadog']['logs_agent_config'] = nil

# For custom gem servers on restricted networks
# This attribute only works on Chef >= 12.3
# Change false to the URL of your custom gem server
default['datadog']['gem_server'] = false

########################################################################
###                  Agent5-only attributes                          ###

# Add one "dd_check:checkname" tag per running check. It makes it possible to slice
# and dice per monitored app (= running Agent Check) on Datadog's backend.
# Agent v5 only.
default['datadog']['create_dd_check_tags'] = nil

# Autorestart agent
# Agent v5 only.
default['datadog']['autorestart'] = false

# Run the agent in developer mode
# Agent v5 only.
default['datadog']['developer_mode'] = false

# How often you want the agent to collect data, in seconds. Any value between
# 15 and 60 is a reasonable interval.
# Agent v5 only.
default['datadog']['check_freq'] = 15

# Use mount points instead of volumes to track disk and fs metrics
# Agent v5 only.
default['datadog']['use_mount'] = false

# Change port the agent is listening to
# Agent v5 only.
default['datadog']['agent_port'] = 17123

# Start a graphite listener on this port
# https://github.com/DataDog/dd-agent/wiki/Feeding-Datadog-with-Graphite
# Agent v5 only.
default['datadog']['graphite'] = false
default['datadog']['graphite_port'] = 17124

# log-parsing configuration
# Agent v5 only.
default['datadog']['dogstreams'] = []

# custom emitter configuration
# Agent v5 only.
default['datadog']['custom_emitters'] = []

# For older integrations that do not consume the conf.d yaml files
# Agent v5 only.
default['datadog']['legacy_integrations']['nagios']['enabled'] = false
default['datadog']['legacy_integrations']['nagios']['description'] = 'Nagios integration'
default['datadog']['legacy_integrations']['nagios']['config']['nagios_log'] = '/var/log/nagios3/nagios.log'
