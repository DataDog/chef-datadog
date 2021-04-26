include_recipe 'datadog::dd-agent'

# Monitor solr
# @see https://github.com/DataDog/chef-datadog/blob/master/templates/default/solr.yaml.erb Solr Example
# @example
#

datadog_monitor 'solr' do
  instances node['datadog']['solr']['instances']
  logs node['datadog']['solr']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
