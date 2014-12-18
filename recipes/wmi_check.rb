include_recipe 'datadog::dd-agent-config'

# Integrate IIS metrics
#
# Simply declare the following attributes
# One instance per server.
#
# node['datadog']['wmi_check']['instances'] = [
#                               {
#                                 "class" => "Win32_OperatingSystem",
#                                 "metrics" => ["[NumberOfProcesses, system.proc.count, gauge]", "[NumberOfUsers, system.users.count, gauge]"]
#                               },
#                               {
#                                 "class" => "Win32_PerfFormattedData_PerfProc_Process",
#                                 "metrics" => ["[PercentProcessorTime, proc.cpu_pct, gauge]"],
#                                 "filters" => ["Name: app1", "Name: app2"],
#                                 "tag_by" => "Name"
#                               }
#                              ]

datadog_monitor 'wmi_check' do
  instances node['datadog']['wmi_check']['instances']
end
