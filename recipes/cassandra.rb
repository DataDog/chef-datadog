include_recipe "datadog::dd-agent"

# Monitor cassandra
# 
# Assuming you have 2 clusters "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node.datadog.cassandra.instances = [
#                                     {
#                                       :host => "localhost",
#                                       :port => "7199",
#                                       :name => "prod",
#                                       :user => "username",
#                                       :password => "secret"
#                                     },
#                                     {
#                                       :host => "localhost",
#                                       :port => "8199",
#                                       :name => "test"
#                                     }
#                                    ]

datadog_ddmonitor :name => "cassandra",:init_config => nil, :instances => node.datadog.cassandra.instances
