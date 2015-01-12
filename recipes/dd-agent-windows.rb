  
windows_package "datadog" do
  source "https://s3.amazonaws.com/ddagent-windows-stable/ddagent-cli.msi"
  action :install
  installer_type :msi
  options "APIKEY=\"#{node['datadog']['api_key']}\""
end

service "DatadogAgent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

