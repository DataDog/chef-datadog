include_recipe 'datadog::dd-agent'

if node['datadog'].include?('http_check')
  datadog_monitor 'http_check' do
    init_config node['datadog']['http_check']['init_config'] if node['datadog']['http_check'].include?('init_config')
    instances node['datadog']['http_check']['instances'] if node['datadog']['http_check'].include?('instances')
  end
end
