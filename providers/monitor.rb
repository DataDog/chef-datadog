# Creates the proper yaml file in /etc/dd-agent/conf.d/

# Defined since Chef 11
use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :add do
  Chef::Log.debug "Adding monitoring for #{new_resource.name}"
  config_dir = node['datadog']['agent6'] ? node['datadog']['agent6_config_dir'] : node['datadog']['config_dir']
  template ::File.join(config_dir, 'conf.d', "#{new_resource.name}.yaml") do
    if node['platform_family'] == 'windows'
      owner 'Administrators'
      rights :full_control, 'Administrators'
      inherits false
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
    notifies :restart, 'service[datadog-agent]', :delayed if node['datadog']['agent_start']
  end

  service 'datadog-agent' do
    service_name node['datadog']['agent_name']
    if node['datadog']['agent6'] &&
      (node['platform'] == 'amazon' || node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7 || node['platform_family'] == 'amazon')
      provider Chef::Provider::Service::Upstart
    end
    # HACK: the restart can fail when we hit systemd's restart limits (by default, 5 starts every 10 seconds)
    # To workaround this, retry once after 5 seconds, and a second time after 10 seconds
    retries 2
    retry_delay 5
  end
end

action :remove do
  config_dir = node['datadog']['agent6'] ? node['datadog']['agent6_config_dir'] : node['datadog']['config_dir']
  confd_dir = ::File.join(config_dir, 'conf.d')
  Chef::Log.debug "Removing #{new_resource.name} from #{confd_dir}"
  file ::File.join(confd_dir, "#{new_resource.name}.yaml") do
    action :delete
    sensitive true if Chef::Resource.instance_methods(false).include?(:sensitive)
    notifies :restart, 'service[datadog-agent]', :delayed if node['datadog']['agent_start']
  end

  service 'datadog-agent' do
    if node['datadog']['agent6'] &&
      (node['platform'] == 'amazon' || node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7 || node['platform_family'] == 'amazon')
      provider Chef::Provider::Service::Upstart
    end
    service_name node['datadog']['agent_name']
  end
end
