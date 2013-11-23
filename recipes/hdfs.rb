#
# Cookbook Name:: datadog
# Recipe:: hdfs
#

include_recipe "datadog::dd-agent"

package "python-pip"
package "python-setuptools"

python_pip "snakebite" do
  version node["datadog"]["hdfs"]["snakebite_version"]
end

datadog_monitor "hdfs" do
  instances node["datadog"]["hdfs"]["instances"]
end
