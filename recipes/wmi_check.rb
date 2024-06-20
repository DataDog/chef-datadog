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

include_recipe '::dd-agent'

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
