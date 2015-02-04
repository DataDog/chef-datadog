include_recipe 'datadog::dd-agent'

# Integrate Akamai metrics into Datadog
#
# Set up attributes following this example.
# If you are running multiple Akamai sites on the same machine
# list them all as hashes.
#
# node.datadog.akamai.instances = [
#                                    {
#                                      "site" => "www.YOURCONFIG.ch"
#                                    }
#                                   ]

datadog_monitor 'akamai' do
  instances node['datadog']['akamai']['instances']
end

template '/etc/dd-agent/checks.d/akamai.py' do
	action :create
	owner 'dd-agent'
	source 'akamai.py.erb'
end


