include_recipe 'datadog::dd-agent'

# Monitor MSSQL

# Set the following attributes
# * `instances` (required)
# Example:

# ```
# node['datadog']['sqlserver'] =
#     instances: [
#     {
#         host: 'localhost',
#         port: 1433,
#         username: 'username',
#         password: 'secret'
#     }]
# }
# ```

datadog_monitor 'sqlserver' do
  instances node['datadog']['sqlserver']['instances']
end
