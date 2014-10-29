include_recipe 'datadog::dd-agent'

# Monitor mongo
#
# node.set['datadog']['mongo']['instances'] = [
#   {
#     'host' => 'localhost',
#     'port' => '27017'
#   }
# ]

datadog_monitor 'mongo' do
  instances node['datadog']['mongo']['instances']
end

cookbook_file "/usr/share/datadog/agent/checks.d/mongo.py" do
	source "mongo.py"
	owner "root"
	group "root"
	mode 00644
	action :create
end
