#
# Cookbook Name:: datadog
# Recipe:: ddtrace-python.rb
#

easy_install_package 'ddtrace' do
  version node['datadog']['ddtrace_python_version']
end
