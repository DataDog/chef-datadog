require 'json'

include_recipe 'datadog::dd-agent'

# install and setup checks
node['datadog']['checkse'].each do |name, config|

    execute "install check #{name}" do
        command "sudo service datadog-agent install #{name}"
    end

    execute "configure check #{name}" do
        puts "sudo service datadog-agent configure #{name} '#{JSON.dump(config)}'"
        command "echo \"sudo service datadog-agent configure #{name} '#{JSON.dump(config)}'\""
    end
end

