# Configure a service via its yaml file

default_action :add

property :cookbook, String, default: 'datadog'

# checks have 3 sections: init_config, instances, logs
# we mimic these here, no validation is performed until the template
# is evaluated.
property :init_config, [Hash, nil], required: false, default: {}
property :instances, Array, required: false, default: []
property :version, [Integer, nil], required: false, default: nil
property :use_integration_template, [TrueClass, FalseClass], required: false, default: false
property :logs, [Array, nil], required: false, default: []

action :add do
  Chef::Log.debug("Adding monitoring for #{new_resource.name}")

  template config_file_path(new_resource.name) do
    # On Windows Agent v5, set the permissions on conf files to Administrators.
    if node['platform_family'] == 'windows'
      if node['datadog']['agent6']
        inherits true # Agent 6/7 rely on inheritance being enabled. Reset it in case it was disabled when installing Agent 5.
      else
        owner 'Administrators'
        rights :full_control, 'Administrators'
        inherits false
      end
    else
      owner 'dd-agent'
      mode '600'
    end

    if new_resource.use_integration_template
      source 'integration.yaml.erb'
    else
      source "#{new_resource.name}.yaml.erb"
    end

    variables(
      init_config: new_resource.init_config,
      instances:   new_resource.instances,
      version:     new_resource.version,
      logs:        new_resource.logs
    )
    cookbook new_resource.cookbook
    sensitive true
  end
end

action :remove do
  Chef::Log.debug("Removing #{new_resource.name} from #{yaml_dir}")

  file ::File.join(yaml_dir, "#{new_resource.name}.yaml") do
    action :delete
    sensitive true
  end
end

def config_file_path(resource_name)
  if node['datadog']['agent6']
    ::File.join(
      node['datadog']['agent6_config_dir'],
      'conf.d',
      "#{resource_name}.d",
      'conf.yaml'
    )
  else
    ::File.join(
      node['datadog']['config_dir'],
      'conf.d',
      "#{resource_name}.yaml"
    )
  end
end
