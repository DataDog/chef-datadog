include_recipe 'datadog::dd-agent'

# Monitor solr
# @see https://github.com/DataDog/integrations-core/blob/master/solr/conf.yaml.example Solr Example
# @example
#

datadog_monitor 'solr' do
  instances node['datadog']['solr']['instances']
  logs node['datadog']['solr']['logs']
end
