include_recipe "datadog::dd-agent"

# Monitor Varnish
# 
# Assuming you have 2 clusters, one tagged and one with a custom
# path to varnishstat
# you need to set up the following attributes
# node.datadog.varnish.instances = [
#   {
#     :varnishstat => "/opt/local/bin/varnishstat"
#   },
#   {
#     :tags => ["test", "cache"]
#   }
# ]


datadog_monitor "varnish" do
  instances node["datadog"]["varnish"]["instances"]
end
