# Creates the proper yaml file in /etc/dd-agent/conf.d/

def whyrun_supported?
  true
end

action :add do
  Chef::Log.info"Adding monitoring for #{new_resource.name}"
  new_resource.updated_by_last_action(false)
  template "/etc/dd-agent/conf.d/#{new_resource.name}.yaml" do
    owner "dd-agent"
    mode 00400
    notifies :restart, resources(:service => "datadog-agent")
    variables(:init_config => new_resource.init_config, :instances => new_resource.instances)
  end
end

action :remove do
  if ::File.exists?("/etc/dd-agent/conf.d/#{new_resource.name}.yaml")
    Chef::Log.info "Un-monitoring #{new_resource.name} from /etc/dd-agent/conf.d/"
    file "/etc/dd-agent/conf.d/#{new_resource.name}.yaml" do
      action :delete
      notifies :restart, resources(:service => "datadog-agent")
    end
    new_resource.updated_by_last_action(true)
  end
end
