powershell_script "openssl" do
 cwd Chef::Config[:file_cache_path]
 code <<-EOH
$TARGETDIR = "c:/Users/Luis/Code/luislavena/knap-build/var/knapsack/software/x86-windows/openssl/1.0.0n/ssl"
if(!(Test-Path -Path $TARGETDIR )){
   New-Item -type directory -path "$TARGETDIR"
}
EOH
end
remote_file "c:\\Users\\Luis\\Code\\luislavena\\knap-build\\var\\knapsack\\software\\x86-windows\\openssl\\1.0.0n\\ssl\\cert.pem" do
  source "http://curl.haxx.se/ca/cacert.pem"
 end
  
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

