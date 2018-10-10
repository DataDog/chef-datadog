#
# Cookbook Name:: datadog
# Recipe:: ddtrace-python
#

python_package 'ddtrace' do
  version node['datadog']['ddtrace_python_version']
end
