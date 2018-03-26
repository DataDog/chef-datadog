#
# Cookbook Name:: datadog
# Recipe:: ddtrace-python
#

# NB: This recipe is compatible with Chef <= 12 only. If you're using Chef 13 or higher
# please refer to the README of the cookbook.

easy_install_package 'ddtrace' do
  version node['datadog']['ddtrace_python_version']
end
