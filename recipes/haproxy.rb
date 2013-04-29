include_recipe "datadog::dd-agent"

# Monitor haproxy

# You need to set up the following attributes
# node.datadog.haproxy.instances = [
#                                     {
#                                       :url => "http://localhost/stats_url",
#                                       :username => "username",
#                                       :password => "secret"
#                                     }
#                                    ]

datadog_ddmonitor "haproxy" do
  instances node["datadog"]["haproxy"]["instances"]
end
