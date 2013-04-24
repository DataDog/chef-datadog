include_recipe "datadog:dd-agent"
# Monitor apache
# 
# Assuming you have 2 instances "test" and "prod"
# you need to set up the following attributes.
# 
# node.datadog.apache.instances = [
#                                  {
#                                   :apache_status_url => "http://localhost:81/status/",
#                                   :tags => ["prod"]
#                                  },
#                                  {
#                                   :apache_status_url => "http://localhost:82/status/",
#                                   :name => ["test"]
#                                  }
#                                 ]

datadog_ddmonitor :name => "apache", :init_config => nil, :instances => node.datadog.apache.instances
