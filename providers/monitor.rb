# Creates the proper yaml file in /etc/dd-agent/conf.d/

# Defined since Chef 11
use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :add do
  Chef::Log.debug "Adding monitoring for #{new_resource.name}"
  template ::File.join(yaml_dir, "#{new_resource.name}.yaml") do
    # On Windows Agent v5, set the permissions on conf files to Administrators.
    if node['platform_family'] == 'windows'
      unless node['datadog']['agent6']
        owner 'Administrators'
        rights :full_control, 'Administrators'
        inherits false
      end
    else
      owner 'dd-agent'
      mode '600'
    end

    source 'integration.yaml.erb' if new_resource.use_integration_template

    variables(
      init_config: new_resource.init_config,
      instances:   new_resource.instances,
      version:     new_resource.version,
      logs:        new_resource.logs
    )
    cookbook new_resource.cookbook
    sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
  end
end

action :remove do
  confd_dir = yaml_dir
  Chef::Log.debug "Removing #{new_resource.name} from #{confd_dir}"
  file ::File.join(confd_dir, "#{new_resource.name}.yaml") do
    action :delete
    sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
  end
end

private

def yaml_dir
  if node['datadog']['agent6']
    ::File.join(node['datadog']['agent6_config_dir'], 'conf.d')
  else
    ::File.join(node['datadog']['config_dir'], 'conf.d')
  end
end
