datadog_integration 'datadog-aerospike' do
  action :remove
  notifies :restart, 'service[datadog-agent]'
end
# This time Chef should mention "up to date"
datadog_integration 'datadog-aerospike' do
  action :remove
end
datadog_integration 'datadog-aerospike' do
  action :install
  version '1.2.0'
end
# This time Chef should mention "up to date"
datadog_integration 'datadog-aerospike' do
  action :install
  version '1.2.0'
end

datadog_integration 'datadog-elastic' do
  action :remove
  notifies :restart, 'service[datadog-agent]'
end
# This time Chef should mention "up to date"
datadog_integration 'datadog-elastic' do
  action :remove
end
datadog_integration 'datadog-elastic' do
  action :install
  version '1.11.0'
end
# This time Chef should mention "up to date"
datadog_integration 'datadog-elastic' do
  action :install
  version '1.11.0'
end
