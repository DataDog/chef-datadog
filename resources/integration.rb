# Install/remove a Datadog integration
# This resource basically wraps the datadog-agent integration command to be able
# to install and remove integrations from a Chef recipe.
# The datadog_resource must be used on a system where the datadog-agent has
# already been setup.

default_action :install

property :name, String, name_attribute: true

property :version, String, required: true

action :install do
  unless node['datadog']['agent6']
    log 'The datadog_integration resource is only available with Agent v6.' do
      level :error
    end
    return
  end

  log "Getting integration #{new_resource.name}" do
    level :debug
  end

  execute 'integration install' do
    command   "\"#{agent_exe_filepath}\" integration install #{new_resource.name}==#{new_resource.version}"
    user      'dd-agent' unless node['platform_family'] == 'windows'
  end
end

action :remove do
  unless node['datadog']['agent6']
    log 'The datadog_integration resource is only available with Agent v6.' do
      level :error
    end
    return
  end

  log "Removing integration #{new_resource.name}" do
    level :debug
  end

  execute 'integration remove' do
    command   "\"#{agent_exe_filepath}\" integration remove #{new_resource.name}"
    user      'dd-agent' unless node['platform_family'] == 'windows'
  end
end

def agent_exe_filepath
  if node['platform_family'] == 'windows'
    # The Windows Agent will always be setup in this path if the _install-windows.rb
    # has been used to install it.
    "C:\\Program\ Files\\Datadog\\Datadog\ Agent\\embedded\\agent.exe"
  else
    '/opt/datadog-agent/bin/agent/agent'
  end
end
