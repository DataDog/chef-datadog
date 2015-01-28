include_recipe 'datadog::dd-agent'

if node['datadog'].include?('tcp_check')
  datadog_monitor 'tcp_check' do
    init_config node['datadog']['tcp_check']['init_config'] if node['datadog']['tcp_check'].include?('init_config')
    instances node['datadog']['tcp_check']['instances'] if node['datadog']['tcp_check'].include?('instances')
  end
end
