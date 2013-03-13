include_recipe "datadog::dd-agent"

package "psycopg2" do
  case node["platform"]
  when "debian", "ubuntu"
    package_name "python-psycopg2"
  when "centos", "redhat", "fedora", "suse"
    package_name "python-psycopg2"
  end
  action :install
end

datadog_ddmonitor :name => "postgres", :init_config => nil, :instances => node.datadog.postgres.instances
