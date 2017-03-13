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

# Values that differ on Windows
# The location of the config folder (containing conf.d)
# The name of the dd agent service
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

# Agent Version
# Default of `nil` will install latest version. On Windows, this will also upgrade to latest
# This attribute accepts either a `string` or `hash` with the key as platform_name and value of package version
# In the case of fedora use platform_name of rhel
# Example:
# default['datadog']['agent_version'] = {
#  'rhel' => '5.9.0-1',
#  'windows' => '5.9.0',
#  'debian' => '1:5.9.0-1'
# }
default['datadog']['agent_version'] = nil

# Agent package action
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

# Default to false to non_local_traffic
# See: https://github.com/DataDog/dd-agent/wiki/Network-Traffic-and-Proxy-Configuration
default['datadog']['non_local_traffic'] = false

# The loopback address the Forwarder and Dogstatsd will bind.
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
default['datadog']['log_file_directory'] = '/var/log/datadog'

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

# Trace functionality settings
default['datadog']['enable_trace_agent'] = false
default['datadog']['extra_sample_rate'] = 1
default['datadog']['max_traces_per_second'] = 10
default['datadog']['receiver_port'] = 8126
default['datadog']['connection_limit'] = 2000

# ddtrace python version
default['datadog']['ddtrace_python_version'] = nil

# ddtrace ruby gem version
default['datadog']['ddtrace_gem_version'] = nil
# For custom gem servers on restricted networks
# This attribute only works on Chef >= 12.3
# Change false to the URL of your custom gem server
default['datadog']['gem_server'] = false
