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

# Repository URLs
default['datadog']['aptrepo'] = "http://apt.datadoghq.com"
default['datadog']['yumrepo'] = "http://yum.datadoghq.com/rpm"

# Boolean to enable debug_mode, which outputs massive amounts of log messages 
# to the /tmp/ directory.
default['datadog']['debug'] = false

# How often you want the agent to collect data, in seconds. Any value between
# 15 and 60 is a reasonable interval.
default['datadog']['check_freq'] = 15

# If running on ec2, use the instance-id as the host identifier
# rather than the hostname.
# If you have set up meaningful hostnames for your EC2 instances, set this to "no"
default['datadog']['use_ec2_instance_id'] = false

# Use mount points instead of volumes to track disk and fs metrics
default['datadog']['use_mount'] = false

# Change port the agent is listening to
default['datadog']['agent_port'] = 17123

# Start a graphite listener on this port
# https://github.com/DataDog/dd-agent/wiki/Feeding-Datadog-with-Graphite
default['datadog']['graphite'] = false
default['datadog']['graphite_port'] = 17124


##
# Service specific attributes, use override in node/role configuration
##

# apache
default['datadog']['apache']['status_url'] = nil   # http://www.example.com/server-status/?auto

# ganglia
default['datadog']['ganglia']['url'] = nil         # localhost
default['datadog']['ganglia']['port'] = 8651

# haproxy
default['datadog']['haproxy']['stats_url'] = nil
default['datadog']['haproxy']['stats_user'] = nil
default['datadog']['haproxy']['stats_password'] = nil

# mysql
default['datadog']['mysql']['server'] = nil        # localhost
default['datadog']['mysql']['user'] = "readonly"
default['datadog']['mysql']['pass'] = "readonly"

# nginx
default['datadog']['nginx']['status_url'] = nil    # http://localhost:81/nginx_status/

# rabbitmq
default['datadog']['rabbitmq']['status_url'] = nil # http://www.example.com:55672/json
default['datadog']['rabbitmq']['user'] = "guest"
default['datadog']['rabbitmq']['pass'] = "guest"

# mongodb
default['datadog']['mongodb']['server'] = nil      # mongodb://my_user:my_pass@localhost/my_db

# postgres
default['datadog']['postgres']['server'] = nil
default['datadog']['postgres']['port'] = 5432
default['datadog']['postgres']['user'] = "datadog"
default['datadog']['postgres']['password'] = nil

# couchdb
default['datadog']['couchdb']['server'] = nil

# jenkins
default['datadog']['jenkins']['home_dir'] = nil    # /var/lib/hudson/

# nagios
default['datadog']['nagios']['log_dir'] = nil      # /usr/local/nagios/etc
default['datadog']['nagios']['conf_dir'] = nil     # /usr/local/nagios/etc

# cassandra
default['datadog']['cassandra']['host'] = nil      # localhost
default['datadog']['cassandra']['port'] = 8080
default['datadog']['cassandra']['nodetool'] = "/usr/bin/nodetool"

# java
default['datadog']['jvm_jmx']['server'] = nil      # localhost:8090
default['datadog']['jvm_jmx']['user'] = nil        # john
default['datadog']['jvm_jmx']['pass'] = nil        # foobar
default['datadog']['jvm_jmx']['name'] = nil        # Java

# tomcat
default['datadog']['tomcat_jmx']['server'] = nil   # localhost
default['datadog']['tomcat_jmx']['user'] = nil     # john
default['datadog']['tomcat_jmx']['pass'] = nil     # foobar

# varnish
default['datadog']['varnish'] = nil               # varnish present? set to true if so

# memcache
default['datadog']['memcached'] = nil

# redis
default['datadog']['redis'] = nil
