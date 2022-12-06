#
# Cookbook:: datadog
# Recipe:: gunicorn
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

# Monitor gunicorn
#
# NB: This check requires the python environment on which gunicorn runs to
# have the `setproctitle` module installed:
# (https://pypi.python.org/pypi/setproctitle/)
#
# Example gunicorn.yaml file:
#
# init_config:
#
#
# instances:
# The name of the gunicorn process. For the following gunicorn server ...
#
#    gunicorn --name my_web_app my_web_app_config.ini
#
#  ... we'd use the name `my_web_app`.
#
# - proc_name: my_web_app

include_recipe '::dd-agent'

datadog_monitor 'gunicorn' do
  instances node['datadog']['gunicorn']['instances']
  logs node['datadog']['gunicorn']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
