# Configure a service via its yaml file

default_action :add

property :name, String, name_attribute: true
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
  log "Adding monitoring for #{new_resource.name}" do
    level :debug
  end

  template ::File.join(node['datadog']['config_dir'], 'conf.d', "#{new_resource.name}.yaml") do
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
    sensitive true
  end
end

action :remove do
  confd_dir = ::File.join(node['datadog']['config_dir'], 'conf.d')

  log "Removing #{new_resource.name} from #{confd_dir}" do
    level :debug
  end

  file ::File.join(confd_dir, "#{new_resource.name}.yaml") do
    action :delete
    sensitive true
  end
end
