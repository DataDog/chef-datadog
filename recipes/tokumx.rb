include_recipe "datadog::dd-agent"

# Monitor tokumx
#
# node.set['datadog']['tokumx']['instances'] = [
#   {
#     'host' => 'localhost',
#     'port' => '27017'
#   }
# ]

package "python-setuptools"

easy_install_package "pymongo"

datadog_monitor "tokumx" do
  instances node["datadog"]["tokumx"]["instances"]
end
