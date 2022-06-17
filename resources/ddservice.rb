resource_name :ddservice
provides :ddservice

default_action :enable

require 'mixlib/shellout'

service_name = 'datadogagent'

action :enable do
    powershell_script 'start the datadog-agent' do
        code "set-service '#{service_name}' -startuptype automaticdelayedstart -Force"
        action :nothing
    end
end

action :disable do
    powershell_script 'start the datadog-agent' do
        code "set-service '#{service_name}' -startuptype disabled -Force"
        action :nothing
    end
end

action :start do
    powershell_script 'start the datadog-agent' do
        code "start-service '#{service_name}' -Force"
        action :nothing
    end
end

action :stop do
    powershell_script 'stop the datadog-agent' do
        code "stop-service '#{service_name}' -Force"
        action :nothing
    end
end

action :restart do
    powershell_script 'restart the datadog-agent' do
        code "restart-service '#{service_name}' -Force"
        action :nothing
    end
end
