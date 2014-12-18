# Creates the proper yaml file in /etc/dd-agent/conf.d/

def whyrun_supported?
  true
end

action :add do
	converge_by("Adding monitoring for #{new_resource.name}") do
		template "#{node['datadog']['configDir']}/conf.d/#{new_resource.name}.yaml" do
			owner 'dd-agent' if !platform_family?('windows')
			mode 00600 if !platform_family?('windows')
			variables(
			  :init_config => new_resource.init_config,
			  :instances   => new_resource.instances
			)
			notifies :restart, 'service[datadog-agent]', :delayed
			new_resource.updated_by_last_action(true)
		end
	end	
end

action :remove do
	if ::File.exist?("#{node['datadog']['configDir']}/conf.d/#{new_resource.name}.yaml")
		converge_by("Removing #{node['datadog']['configDir']}/conf.d/#{new_resource.name}.yaml") do
			resource = file "#{node['datadog']['configDir']}/conf.d/#{new_resource.name}.yaml" do
				action :delete
				notifies :restart, 'service[datadog-agent]', :delayed
				new_resource.updated_by_last_action(true)
			end
		end
	end
end
