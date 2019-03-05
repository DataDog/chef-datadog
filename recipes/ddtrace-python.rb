#
# Cookbook Name:: datadog
# Recipe:: ddtrace-python
#

# NB: This recipe is compatible with Chef <= 12 only. If you're using Chef 13 or higher
# please refer to the README of the cookbook.

log 'message' do
  message 'This recipe will be deprecated in version 3.0.0 of the cookbook. See README.md chapter ddtrace-python for more infos.'
  level :warn
end

easy_install_package 'ddtrace' do
  version node['datadog']['ddtrace_python_version']
end
