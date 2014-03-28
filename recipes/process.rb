include_recipe "datadog::dd-agent"

# Monitor processes
#
#  - name: (mandatory) STRING Is the display name of the check, it will be system.name.processes
#    search_string: (mandatory) LIST OF STRINGS If one of the element in the list matches,
#                    return the counter of all the processes that contain the string
#    exact_match: (optional) True/False, default to False, if you want to look for an arbitrary
#                 string, use exact_match: False, unless use the exact base name of the process
#
# Example:
#
# node.datadog.process.instances = [
#   {
#     :name => "ssh",
#     :search_string => ["ssh","sshd"],
#     :exact_match => False
#   },
#   {
#     :name => "postgres",
#     :search_string => ["postgres"],
#   },
# ]

datadog_monitor "process" do
  instances node['datadog']['process']['instances']
end
