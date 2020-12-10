source 'https://supermarket.chef.io'

metadata

group :integration do
  cookbook 'sudo' # Use '< 5.0.0' with Chef < 13
  cookbook 'test', path: './test/cookbooks/test' # Used to test custom resources (datadog_monitor, integration)
end
