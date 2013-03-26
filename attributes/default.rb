#
# Cookbook Name:: datadog
# Attributes:: default
#
# Copyright 2011-2012, Datadog
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

# Place your API Key here, or set it on the role/environment/node
# The Datadog api key to associate your agent's data with your organization.
# Can be found here:
# https://app.datadoghq.com/account/settings
default['datadog']['api_key'] = nil

# Create an application key on the Account Settings page
default['datadog']['application_key'] = nil

# Don't change these
# The host of the Datadog intake server to send agent data to
default['datadog']['url'] = "https://app.datadoghq.com"

# Add tags as override attributes in your role  
default['datadog']['tags'] = ""

# Repository configuration
default['datadog']['installrepo'] = true
default['datadog']['aptrepo'] = "http://apt.datadoghq.com"
default['datadog']['yumrepo'] = "http://yum.datadoghq.com/rpm"

# Agent Version
default['datadog']['agent_version'] = nil

# Boolean to enable debug_mode, which outputs massive amounts of log messages 
# to the /tmp/ directory.
default['datadog']['debug'] = false

# How often you want the agent to collect data, in seconds. Any value between
# 15 and 60 is a reasonable interval.
default['datadog']['check_freq'] = 15

# If running on ec2, if true, use the instance-id as the host identifier
# rather than the hostname for the agent or nodename for chef-handler.
default['datadog']['use_ec2_instance_id'] = false

# Use mount points instead of volumes to track disk and fs metrics
default['datadog']['use_mount'] = false

# Change port the agent is listening to
default['datadog']['agent_port'] = 17123

# Start a graphite listener on this port
# https://github.com/DataDog/dd-agent/wiki/Feeding-Datadog-with-Graphite
default['datadog']['graphite'] = false
default['datadog']['graphite_port'] = 17124

# Start dogstatsd by default
default['datadog']['dogstatsd'] = true
default['datadog']['dogstatsd_port'] = 8125
default['datadog']['dogstatsd_interval'] = 10

# Set up dogstreams
default['datadog']['dogstreams'] = []

##
# Service specific attributes, use override in node/role configuration
##

# apache
default['apache']['status_url'] = nil   # http://www.example.com/server-status/?auto

# ganglia
default['ganglia']['url'] = nil         # localhost
default['ganglia']['port'] = 8651

# haproxy
default['haproxy']['stats_url'] = nil
default['haproxy']['stats_user'] = nil
default['haproxy']['stats_password'] = nil

# mysql
default['mysql']['server'] = nil        # localhost
default['mysql']['user'] = "readonly"
default['mysql']['pass'] = "readonly"

# nginx
default['nginx']['status_url'] = nil    # http://localhost:81/nginx_status/

# rabbitmq
default['rabbitmq']['status_url'] = nil # http://www.example.com:55672/json
default['rabbitmq']['user'] = "guest"
default['rabbitmq']['pass'] = "guest"

# mongodb
default['mongodb']['server'] = nil      # mongodb://my_user:my_pass@localhost/my_db

# postgres
default['postgres']['server'] = nil
default['postgres']['port'] = 5432
default['postgres']['user'] = "datadog"
default['postgres']['password'] = nil

# couchdb
default['couchdb']['server'] = nil

# jenkins
default['jenkins']['home_dir'] = nil    # /var/lib/hudson/

# nagios
default['nagios']['log_dir'] = nil      # /usr/local/nagios/etc
default['nagios']['conf_dir'] = nil     # /usr/local/nagios/etc

# cassandra
default['cassandra']['host'] = nil      # localhost
default['cassandra']['port'] = 8080
default['cassandra']['nodetool'] = "/usr/bin/nodetool"

# java
default['jvm_jmx']['server'] = nil      # localhost:8090
default['jvm_jmx']['user'] = nil        # john
default['jvm_jmx']['pass'] = nil        # foobar
default['jvm_jmx']['name'] = nil        # Java

# tomcat
default['tomcat_jmx']['server'] = nil   # localhost
default['tomcat_jmx']['user'] = nil     # john
default['tomcat_jmx']['pass'] = nil     # foobar

# varnish
default['varnish'] = nil               # varnish present? set to true if so

# memcache
default['memcached'] = nil

# redis
default['redis'] = nil
