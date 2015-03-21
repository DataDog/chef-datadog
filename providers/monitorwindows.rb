# Creates the proper yaml file in

def whyrun_supported?
  true
end

action :add do
  Chef::Log.debug "Adding monitoring for windows #{new_resource.name}"
  template "C:\\Documents and Settings\\All Users\\Application Data\\Datadog\\conf.d\\#{new_resource.name}.yaml" do
    mode 00600
    variables(
      :init_config => new_resource.init_config,
      :instances   => new_resource.instances
    )
    notifies :restart, 'service[DatadogAgent]', :delayed
  end
  new_resource.updated_by_last_action(false)
end

action :remove do
  if ::File.exist?("C:\\Documents and Settings\\All Users\\Application Data\\Datadog\\conf.d\\#{new_resource.name}.yaml")
    Chef::Log.debug "Removing #{new_resource.name} from C:\\Documents and Settings\\All Users\\Application Data\\Datadog\\conf.d"
    file "C:\\Documents and Settings\\All Users\\Application Data\\Datadog\\conf.d\\#{new_resource.name}.yaml" do
      action :delete
      notifies :restart, 'service[datadog-agent]', :delayed
    end
    new_resource.updated_by_last_action(true)
  end
end
