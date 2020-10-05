#
# Cookbook:: datadog
# Recipe:: gunicorn
#

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

include_recipe 'datadog::dd-agent'

datadog_monitor 'gunicorn' do
  instances node['datadog']['gunicorn']['instances']
  logs node['datadog']['gunicorn']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
