# Creates the proper yaml file in /etc/dd-agent/conf.d/

# Defined since Chef 11
use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :add do
  Chef::Log.debug "Adding monitoring for #{new_resource.name}"
  template "/etc/dd-agent/conf.d/#{new_resource.name}.yaml" do
    owner 'dd-agent'
    mode 00600
    variables(
      :init_config => new_resource.init_config,
      :instances   => new_resource.instances
    )
    notifies :restart, 'service[datadog-agent]', :delayed
  end

  service 'datadog-agent'
end

action :remove do
  Chef::Log.debug "Removing #{new_resource.name} from /etc/dd-agent/conf.d/"
  file "/etc/dd-agent/conf.d/#{new_resource.name}.yaml" do
    action :delete
    notifies :restart, 'service[datadog-agent]', :delayed
  end

  service 'datadog-agent'
end
