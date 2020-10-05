#
# Cookbook:: datadog
# Recipe:: ddtrace-ruby.rb
#

gem_package 'ddtrace' do
  version node['datadog']['ddtrace_gem_version']
end
