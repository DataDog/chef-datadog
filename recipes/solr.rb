include_recipe 'datadog::dd-agent'

# Monitor solr
# @see https://github.com/DataDog/dd-agent/blob/master/conf.d/solr.yaml.example Solr Example
# @example
#

datadog_monitor 'solr' do
  instances node['datadog']['solr']['instances']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
