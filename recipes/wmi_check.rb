include_recipe 'datadog::dd-agent'

# see example configuration file here:
# https://github.com/DataDog/integrations-core/blob/master/wmi_check/conf.yaml.example

# node['datadog']['wmi_check'] =
# {
#   "instances": [
#     {
#       "class": "Win32_OperatingSystem",
#       "metrics": [
#         [
#           "NumberOfProcesses",
#           "system.proc.count",
#           "gauge"
#         ],
#         [
#           "NumberOfUsers",
#           "system.users.count",
#           "gauge"
#         ]
#       ]
#     },
#     {
#       "class": "Win32_PerfFormattedData_PerfProc_Process",
#       "metrics": [
#         [
#           "ThreadCount",
#           "my_app.threads.count",
#           "gauge"
#         ],
#        [
#           "VirtualBytes",
#           "my_app.mem.virtual",
#           "gauge"
#         ]
#       ],
#       "filters": [
#         {
#           "Name": "myapp"
#         }
#       ],
#       "constant_tags": [
#         "role:test"
#       ]
#     },
#     {
#       "class": "Win32_PerfFormattedData_PerfProc_Process",
#       "metrics": [
#         [
#           "ThreadCount",
#           "proc.threads.count",
#           "gauge"
#         ],
#         [
#           "VirtualBytes",
#           "proc.mem.virtual",
#           "gauge"
#         ],
#         [
#           "PercentProcessorTime",
#           "proc.cpu_pct",
#           "gauge"
#         ]
#       ],
#       "filters": [
#         {
#           "Name": "app1"
#         },
#         {
#           "Name": "app2"
#         },
#         {
#           "Name": "app3"
#         }
#       ],
#       "tag_by": "Name"
#     },
#     {
#       "class": "Win32_PerfFormattedData_PerfProc_Process",
#       "metrics": [
#         [
#           "IOReadBytesPerSec",
#           "proc.io.bytes_read",
#           "gauge"
#         ]
#       ],
#       "filters": [
#         {
#           "Name": "app%"
#         }
#       ],
#       "tag_by": "Name",
#       "tag_queries": [
#         [
#           "IDProcess",
#           "Win32_Process",
#           "Handle",
#           "CommandLine"
#         ]
#       ]
#     }
#   ],
#   "logs": null
# }

datadog_monitor 'wmi_check' do
  init_config node['datadog']['wmi_check']['init_config']
  instances node['datadog']['wmi_check']['instances']
  logs node['datadog']['wmi_check']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
