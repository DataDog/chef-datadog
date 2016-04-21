include_recipe 'datadog::dd-agent'

# Build a data structure with configuration.
# @see https://github.com/DataDog/dd-agent/blob/master/conf.d/php_fpm.yaml.example PHP-FPM Example
# @example
#   node.override['datadog']['php_fpm']['instances'] = [
#     {
#       'status_url' => 'http://localhost/status',
#       'ping_url' => 'http://localhost/ping',
#       'ping_reply' => 'pong',
#       'user' => 'bits',
#       'password' => 'D4T4D0G',
#       'tags' => ['prod']
#     }
#   ]
datadog_monitor 'php_fpm' do
  instances node['datadog']['php_fpm']['instances']
end
