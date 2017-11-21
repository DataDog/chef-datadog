include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @see https://github.com/DataDog/dd-agent/blob/master/conf.d/jmx.yaml.example JMX Example
# @example
#   node.override['datadog']['jmx']['instances'] = [
#     {
#       'host' => 'localhost',
#       'port' => 7199,
#       'name' 'prod_jmx_app',
#       'conf' => [
#         'include' => {
#           'attribute' => ['Capacity', 'Used'],
#           'bean_name' => 'com.datadoghq.test:type=BeanType,tag1=my_bean_name',
#           'domain' => 'com.datadoghq.test'
#         }
#       ]
#     }
#   ]
datadog_monitor 'jmx' do
  instances node['datadog']['jmx']['instances']
  logs node['datadog']['jmx']['logs']
end
