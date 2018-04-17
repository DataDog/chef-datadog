#
# Cookbook Name:: datadog
# Attributes:: default
#
# Copyright 2011-2015, Datadog
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

########################################################################
###                  Agent6-only attributes                          ###

# If you're installing a pre-release version of Agent 6 (beta or RC), you need to:
# * on debian: set node['datadog']['agent6_aptrepo_dist'] to 'beta' instead of 'stable'
# * on RHEL: set node['datadog']['agent6_yumrepo'] to 'https://yum.datadoghq.com/beta/x86_64/'
# In all cases, follow the instructions below:

# Set node['datadog']['agent6'] to true to install an agent6 instead of agent5.
# To upgrade from agent5 to agent6, you need to:
# * set node['datadog']['agent6'] to true, and
# * either set node['datadog']['agent6_version'] to an existing agent6 version (recommended), or
#   set node['datadog']['agent6_package_action'] to 'upgrade'
# To downgrade from agent6 to agent5, you need to:
# * set node['datadog']['agent6'] to false, and
# * pin node['datadog']['agent_version'] to an existing agent5 version, and
# * set node['datadog']['agent_allow_downgrade'] to true
default['datadog']['agent6'] = false
# Default of `nil` will install latest version, applies to agent6 only.
# See documentation of `agent_version` attribute for allowed configuration format.
default['datadog']['agent6_version'] = nil
default['datadog']['agent6_package_action'] = 'install' # set to `upgrade` to always upgrade to latest

# repos where datadog-agent v6 packages are available
default['datadog']['agent6_aptrepo'] = 'http://apt.datadoghq.com'
default['datadog']['agent6_aptrepo_dist'] = 'stable'
# RPMs are only available for RHEL >= 6 (-> use https protocol) and x86_64 arch
default['datadog']['agent6_yumrepo'] = 'https://yum.datadoghq.com/stable/6/x86_64/'

# Values that differ on Windows
# The location of the config folder (containing conf.d)
default['datadog']['agent6_config_dir'] =
  if node['platform_family'] == 'windows'
    "#{ENV['ProgramData']}/Datadog"
  else
    '/etc/datadog-agent'
  end

# Set a key to true to make the agent6 use the v2 api on that endpoint, false otherwise.
# Leave key value to nil to use agent6 default for that endpoint.
# Supported keys: "series", "events", "service checks"
default['datadog']['use_v2_api'] = {}

###                 End of Agent6-only attributes                    ###
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

# Don't change these
# The host of the Datadog intake server to send agent data to
default['datadog']['url'] = 'https://app.datadoghq.com'

# Add tags as override attributes in your role
# This can be a string of comma separated tags or a hash in this format:
# default['datadog']['tags'] = { 'datacenter' => 'us-east' }
# Thie above outputs a string: 'datacenter:us-east'
# When using the Datadog Chef Handler, tags are set on the node with preset prefixes:
# `env:node.chef_environment`, `role:node.node.run_list.role`, `tag:somecheftag`
default['datadog']['tags'] = ''

# Add one "dd_check:checkname" tag per running check. It makes it possible to slice
# and dice per monitored app (= running Agent Check) on Datadog's backend.
default['datadog']['create_dd_check_tags'] = nil

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

# Autorestart agent
default['datadog']['autorestart'] = false

# Run the agent in developer mode
default['datadog']['developer_mode'] = false

# Repository configuration
architecture_map = {
  'i686' => 'i386',
  'i386' => 'i386',
  'x86' => 'i386'
}
architecture_map.default = 'x86_64'

# Older versions of yum embed M2Crypto with SSL that doesn't support TLS1.2
yum_protocol =
  if node['platform_family'] == 'rhel' && node['platform_version'].to_i < 6
    'http'
  else
    'https'
  end

# NB: if you're not using the default repos and/or distributions, make sure
# to pin the version you're installing with node['datadog']['agent_version']
default['datadog']['installrepo'] = true
default['datadog']['aptrepo'] = 'http://apt.datadoghq.com'
default['datadog']['aptrepo_dist'] = 'stable'
default['datadog']['yumrepo'] = "#{yum_protocol}://yum.datadoghq.com/rpm/#{architecture_map[node['kernel']['machine']]}/"
default['datadog']['yumrepo_gpgkey'] = "#{yum_protocol}://yum.datadoghq.com/DATADOG_RPM_KEY.public"
default['datadog']['yumrepo_proxy'] = nil
default['datadog']['yumrepo_proxy_username'] = nil
default['datadog']['yumrepo_proxy_password'] = nil
default['datadog']['windows_agent_url'] = 'https://s3.amazonaws.com/ddagent-windows-stable/'

# Location of additional rpm gpgkey to import (with signature `e09422b3`). In the future the rpm packages
# of the Agent will be signed with this key.
default['datadog']['yumrepo_gpgkey_new'] = "#{yum_protocol}://yum.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public"

# Agent installer checksum
# Expected checksum to validate correct agent installer is downloaded (Windows only)
default['datadog']['windows_agent_checksum'] = nil

# Set to `true` to use the EXE installer on Windows, recommended to gracefully handle upgrades from per-user
# to per-machine installs on most environments. We recommend setting this option to `true` for Agent upgrades from
# versions <= 5.10.1 to versions >= 5.12.0.
# The EXE installer exists since Agent release 5.12.0. It is not provided for >= 6.0.0 versions.
# If you're already using version >= 5.12.0 of the Agent, leave this to false.
default['datadog']['windows_agent_use_exe'] = false

# Values that differ on Windows
# The location of the config folder (containing conf.d)
# The name of the dd agent service
# The log file directory (see logging section below)
if node['platform_family'] == 'windows'
  default['datadog']['config_dir'] = "#{ENV['ProgramData']}/Datadog"
  default['datadog']['agent_name'] = 'DatadogAgent'
else
  default['datadog']['config_dir'] = '/etc/dd-agent'
  default['datadog']['agent_name'] = 'datadog-agent'
end

# DEPRECATED, will be removed after the release of datadog-agent 6.0
# Set to true to always install datadog-agent-base (usually only installed on
# systems with a version of Python lower than 2.6) instead of datadog-agent
#
# The .gsub is done because some platforms may append characters that aren't valid for a Gem::Version comparison.
begin
  default['datadog']['install_base'] = Gem::Version.new(node['languages']['python']['version'].gsub(/(\d\.\d\.\d).+/, '\\1')) < Gem::Version.new('2.6.0')
rescue NoMethodError # nodes['languages']['python'] == nil
  Chef::Log.warn 'no version of python found, please install Agent version 5.x or higher.' unless platform_family?('windows')
rescue ArgumentError
  Chef::Log.warn "could not parse python version string: #{node['languages']['python']['version']}"
end

# Agent Version for v5 Agents
# To pin the version of v6 Agents, use the `agent6_version` attribute instead.
# Default of `nil` will install latest version. On Windows, this will also upgrade to latest
# This attribute accepts either a `string` or `hash` with the key as platform_name and value of package version
# In the case of fedora and amazon linux, use platform_name of rhel
# Example:
# default['datadog']['agent_version'] = {
#  'rhel' => '5.9.0-1',
#  'windows' => '5.9.0',
#  'debian' => '1:5.9.0-1'
# }
default['datadog']['agent_version'] = nil

# Agent package action for v5 Agents
# For v6 Agents, use the agent6_package_action attribute instead
# Allow override with `upgrade` to get latest (Linux only)
default['datadog']['agent_package_action'] = 'install'

# Agent package options
# retries and retry_delay for package download/install
default['datadog']['agent_package_retries'] = nil
default['datadog']['agent_package_retry_delay'] = nil

# Allow downgrades of the agent (Linux only)
# Note: on apt-based platforms, this will use the `--force-yes` option on the apt-get command. Use with caution.
default['datadog']['agent_allow_downgrade'] = false

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

# How often you want the agent to collect data, in seconds. Any value between
# 15 and 60 is a reasonable interval.
default['datadog']['check_freq'] = 15

# Specify agent hostname
# More information available here: http://docs.datadoghq.com/hostnames/#agent
default['datadog']['hostname'] = node.name

# If running on ec2, if true, use the instance-id as the host identifier
# rather than the hostname for chef-handler.
default['datadog']['use_ec2_instance_id'] = false

# Use mount points instead of volumes to track disk and fs metrics
default['datadog']['use_mount'] = false

# Change port the agent is listening to
default['datadog']['agent_port'] = 17123

# Enable the agent to start at boot
default['datadog']['agent_enable'] = true

# Start agent or not
default['datadog']['agent_start'] = true

# Start a graphite listener on this port
# https://github.com/DataDog/dd-agent/wiki/Feeding-Datadog-with-Graphite
default['datadog']['graphite'] = false
default['datadog']['graphite_port'] = 17124

# log-parsing configuration
default['datadog']['dogstreams'] = []

# custom emitter configuration
default['datadog']['custom_emitters'] = []

# Logging configuration
default['datadog']['syslog']['active'] = false
default['datadog']['syslog']['udp'] = false
default['datadog']['syslog']['host'] = nil
default['datadog']['syslog']['port'] = nil
default['datadog']['log_file_directory'] =
  if node['platform_family'] == 'windows'
    nil # let the agent use a default log file dir
  else
    '/var/log/datadog'
  end

# Web proxy configuration
default['datadog']['web_proxy']['host'] = nil
default['datadog']['web_proxy']['port'] = nil
default['datadog']['web_proxy']['user'] = nil
default['datadog']['web_proxy']['password'] = nil
default['datadog']['web_proxy']['skip_ssl_validation'] = nil # accepted values 'yes' or 'no'

# dogstatsd
default['datadog']['dogstatsd'] = true
default['datadog']['dogstatsd_port'] = 8125
default['datadog']['dogstatsd_interval'] = 10
default['datadog']['dogstatsd_normalize'] = 'yes'
default['datadog']['dogstatsd_target'] = 'http://localhost:17123'
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

# For older integrations that do not consume the conf.d yaml files
default['datadog']['legacy_integrations']['nagios']['enabled'] = false
default['datadog']['legacy_integrations']['nagios']['description'] = 'Nagios integration'
default['datadog']['legacy_integrations']['nagios']['config']['nagios_log'] = '/var/log/nagios3/nagios.log'

# Service discovery settings
# Enable with service_discovery_backend ('docker' is only valid option currently)
default['datadog']['sd_backend_host'] = '127.0.0.1'
default['datadog']['sd_backend_port'] = 4001
default['datadog']['sd_config_backend'] = 'etcd'
default['datadog']['sd_template_dir'] = '/datadog/check_configs'
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
# `connection_limit` is ignored in Agent 6
default['datadog']['connection_limit'] = nil

# ddtrace python version
default['datadog']['ddtrace_python_version'] = nil

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

# Logs functionality settings (Agent 6 only)
# Set `enable_log_agent` to:
# * `true` to explicitly enable the log agent
# * `false` to explicitly disable it
# Leave it to `nil` to let the agent's default behavior decide whether to run the log-agent
default['datadog']['enable_logs_agent'] = nil

# For custom gem servers on restricted networks
# This attribute only works on Chef >= 12.3
# Change false to the URL of your custom gem server
default['datadog']['gem_server'] = false
