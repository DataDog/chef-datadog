# Creates the proper yaml file in /etc/dd-agent/checks.e/<checks/uri>

def whyrun_supported?
  true
end

action :add do
  Chef::Log.debug "Adding monitoring for #{new_resource.name}"  # FIXME hardcoded links
  template "/home/vagrant/dd-agent/checks.e/#{new_resource.name}/check.yaml" do
    owner 'dd-agent'
    mode 00600
    local true
    source "/home/vagrant/dd-agent/checks.e/#{new_resource.name}/check.yaml.erb"
    variables(
      :init_config => new_resource.init_config,
      :instances   => new_resource.instances
    )
    notifies :restart, 'service[datadog-agent]', :delayed
  end
  new_resource.updated_by_last_action(false)
end

action :remove do
  if ::File.exist?("/home/vagrant/dd-agent/checks.e/#{new_resource.name}/check.yaml")
    Chef::Log.debug "Removing #{new_resource.name} from /etc/dd-agent/checks.e/"
    file "/home/vagrant/dd-agent/checks.e/#{new_resource.name}/check.yaml" do
      action :delete
      notifies :restart, 'service[datadog-agent]', :delayed
    end
    new_resource.updated_by_last_action(true)
  end
end
