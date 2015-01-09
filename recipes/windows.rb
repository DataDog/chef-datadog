  

  windows_package "datadog" do
    source "https://s3.amazonaws.com/ddagent-windows-stable/ddagent-cli.msi"
    action :install
    installer_type :msi
    options "APIKEY=\"8811f4162b1cc39f60b0a297b88fedfa\""
  end
  
#msiexec /qn /i ddagent-cli.msi APIKEY="8811f4162b1cc39f60b0a297b88fedfa" HOSTNAME="my_hostname" TAGS="mytag1,mytag2"
