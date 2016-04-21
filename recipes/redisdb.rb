include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @see https://github.com/DataDog/dd-agent/blob/master/conf.d/redisdb.yaml.example RedisDB Example
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
end
