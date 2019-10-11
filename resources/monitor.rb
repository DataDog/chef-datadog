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

  template ::File.join(yaml_dir, "#{new_resource.name}.yaml") do
    # On Windows Agent v5, set the permissions on conf files to Administrators.
    if node['platform_family'] == 'windows'
      if node['datadog']['agent_major_version'].to_i == 5
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

def yaml_dir
  is_agent5 = node['datadog']['agent_major_version'].to_i == 5
  is_windows = node['platform_family'] == 'windows'
  if is_windows
    "#{ENV['ProgramData']}/Datadog/conf.d"
  else
    is_agent5 ? '/etc/dd-agent/conf.d' : '/etc/datadog-agent/conf.d'
  end
end
