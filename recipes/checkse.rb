require 'json'

include_recipe 'datadog::dd-agent'

# install and setup checks
node['datadog']['checkse'].each do |name, config|

    execute "install check #{name}" do
        command "sudo service datadog-agent install #{name}"
    end

    if not name.include? "/"
        name = 'tmichelet/dd-' + name + '-check'  # FIXME
    end
    datadog_check_monitor name do
      init_config config['init_config']
      instances config['instances']
    end

end

