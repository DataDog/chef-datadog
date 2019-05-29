# Shared helper for all serverspec tests
require 'json_spec'
require 'serverspec'
require 'yaml'

# manually determine if the platform is Windows or not
# Serverspec as of v2.24 cannot detect the OS family of Windows target hosts
# For reference see https://github.com/serverspec/serverspec/blob/master/WINDOWS_SUPPORT.md
if ENV['OS'] == 'Windows_NT'
  set :backend, :cmd
  # On Windows, set the target host's OS explicitly
  set :os, :family => 'windows'
  @agent_package_name = 'Datadog Agent'
  @agent_service_name = 'DatadogAgent'
  @agent_config_dir = "#{ENV['ProgramData']}/Datadog"
else
  set :backend, :exec
  @agent_package_name = 'datadog-agent'
  @agent_service_name = 'datadog-agent'
  @agent_config_dir = '/etc/datadog-agent'
end

set :path, '/sbin:/usr/local/sbin:$PATH' unless os[:family] == 'windows'
