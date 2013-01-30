# monitor cassandra
include_recipe "datadog::dd-agent"

cookbook_file "/etc/dd-agent/conf.d/cassandra.yaml" do
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "datadog-agent")
end
