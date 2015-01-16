include_recipe 'datadog::dd-agent'

# Monitor solr
#
# Assuming you have 2 instances "test" and "prod",
# one with and one without authentication
# you need to set up the following attributes
# node.datadog.solr.instances = [
#   {
#     :server => "localhost",
#     :port => "8983",
#     :name => "prod",
#     :username => "username",
#     :password => "secret"
#   },
#   {
#     :server => "localhost",
#     :port => "8983",
#     :name => "test"
#   }
# ]

datadog_monitor 'solr' do
  instances node['datadog']['solr']['instances']
end
