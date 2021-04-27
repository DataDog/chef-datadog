include_recipe 'datadog::dd-agent'

# Monitor solr
# @see https://github.com/DataDog/integrations-core/blob/master/solr/datadog_checks/solr/data/conf.yaml.example Solr Example
# @example
#

datadog_monitor 'solr' do
  instances node['datadog']['solr']['instances']
  logs node['datadog']['solr']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
