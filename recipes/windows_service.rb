#
# Cookbook:: datadog
# Recipe:: windows_service
#
# Copyright:: 2011-Present, Datadog
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

# Example windows_service.yaml file:
#
# init_config:
#
# instances:
# For each instance you define what host to connect to (defaulting to the
# current host) as well as a list of services you care about. The service
# names should match the Service name in the properties and NOT the display
# name in the services.msc list.
#
# If you want to check services on a remote host, you have to specify a
# hostname and (optional) credentials
#
#-  host: MYREMOTESERVER
#   username: MYREMOTESERVER\fred
#   password: mysecretpassword
#   tags:
#     - fredserver
#
# The sample configuration will monitor the WMI Performance Adapter service,
# named "wmiApSrv" in the service properties.
#
# - host: . # "." means the current host
#  services:
#    - wmiApSrv # service names are not case-sensitive

# Example attributes for monitoring local Windows service:
#
# node['datadog']['windows_service']['instances'] = {
#   "instances": [
#     {
#       "services": ["RemoteServiceName"],
#       "host": "."
#     }
#   ]
# }

# Example attributes for monitoring remote Windows service:
#
# node['datadog']['windows_service']['instances'] = {
#   "instances": [
#     {
#       "username": "RemoteHostname\thomas",
#       "services": ["RemoteServiceName1", "RemoteServiceName2"],
#       "host": "RemoteHostName",
#       "password": "secretpw"
#     }
#   ]
# }

include_recipe '::dd-agent'

datadog_monitor 'windows_service' do
  instances node['datadog']['windows_service']['instances']
  logs node['datadog']['windows_service']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
