include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @see https://github.com/DataDog/integrations-core/blob/master/redisdb/conf.yaml.example RedisDB Example
# @example
#   node.override['datadog']['redisdb']['instances'] = [
#     {
#       'server' => 'localhost',
#       'port' => '6379',
#       'password' => 'somesecret',
#       'tags' => ['prod']
#     }
#   ]
datadog_monitor 'redisdb' do
  instances node['datadog']['redisdb']['instances']
  logs node['datadog']['redisdb']['logs']
end
