# Creates the proper yaml file in /etc/dd-agent/conf.d/

# Defined since Chef 11
use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

def install_custom_check(name, cookbook, source)
  cookbook_file ::File.join(node['datadog']['config_dir'], 'checks.d', "#{name}.py") do
    cookbook cookbook unless cookbook.nil?
    source source unless source.nil?
    owner 'dd-agent'
    mode '644'
  end
end

action :add do
  Chef::Log.debug "Adding monitoring for #{new_resource.name}"
  install_custom_check(new_resource.name, new_resource.check_cookbook, new_resource.check_source) if new_resource.custom_check

  template ::File.join(node['datadog']['config_dir'], 'conf.d', "#{new_resource.name}.yaml") do
    if node['platform_family'] == 'windows'
      owner 'Administrators'
      rights :full_control, 'Administrators'
      inherits false
    else
      owner 'dd-agent'
      mode '600'
    end

    source 'integration.yaml.erb' if new_resource.use_integration_template || new_resource.custom_check

    variables(
      init_config: new_resource.init_config,
      instances:   new_resource.instances,
      version:     new_resource.version
    )
    cookbook new_resource.cookbook
    sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
    notifies :restart, 'service[datadog-agent]', :delayed if node['datadog']['agent_start']
  end

  service 'datadog-agent' do
    service_name node['datadog']['agent_name']
  end
end

action :remove do
  confd_dir = ::File.join(node['datadog']['config_dir'], 'conf.d')
  Chef::Log.debug "Removing #{new_resource.name} from #{confd_dir}"
  file ::File.join(confd_dir, "#{new_resource.name}.yaml") do
    action :delete
    sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
    notifies :restart, 'service[datadog-agent]', :delayed if node['datadog']['agent_start']
  end

  service 'datadog-agent' do
    service_name node['datadog']['agent_name']
  end
end
