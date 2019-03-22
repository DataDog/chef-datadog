include_recipe 'datadog::dd-agent'

# see example configuration file here:
# https://github.com/DataDog/integrations-core/blob/master/sqlserver/conf.yaml.example

# Example 1 - Optionally, custom Metrics have been configured under init_config
# node['datadog']['sqlserver'] =
# {
#   "instances": [
#     {
#       "host": "fakehostname,1433",
#       "connector": "odbc",
#       "driver": "SQL Server",
#       "username": "fake_user",
#       "password": "bogus_pw",
#       "command_timeout": 30,
#       "database": "fake_db_name",
#       "tags": [
#         "test_tag_name"
#       ]
#     }
#   ],
#   "init_config": {
#     "custom_metrics": [
#       {
#         "name": "sqlserver.clr.execution",
#         "counter_name": "CLR execution"
#       },
#       {
#         "name": "sqlserver.exec.in_progress",
#         "counter_name": "OLEDB calls",
#         "instance_name": "Cumulative execution time (ms) per second"
#       },
#       {
#         "name": "sqlserver.db.commit_table_entries",
#         "counter_name": "Log Flushes/sec",
#         "instance_name": "ALL",
#         "tag_by": "db"
#       }
#     ]
#   }
# }

# Example 2 - Optionally, custom Metrics have not been configured
# node['datadog']['sqlserver'] =
# {
#   "instances": [
#     {
#       "host": "fakehostname,1433",
#       "connector": "odbc",
#       "driver": "SQL Server",
#       "username": "fake_user",
#       "password": "bogus_pw",
#       "command_timeout": 30,
#       "database": "fake_db_name",
#       "tags": [
#         "test_tag_name"
#       ]
#     }
#   ]
# }

datadog_monitor 'sqlserver' do
  init_config node['datadog']['sqlserver']['init_config']
  instances node['datadog']['sqlserver']['instances']
  logs node['datadog']['sqlserver']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
