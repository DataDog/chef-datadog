include_recipe 'datadog::dd-agent'

#
# The monitor grabs data for all Keynote properties. Add them to
# your role if you want them tagged with anything unique.
#
# node.datadog.keynote = {
#	 "api_url" : "https://api.keynote.com/keynote/api/getdashboarddata",
#    "api_key" : "xxxxxxxxxxxxxxxxxx",
#    "api_timeout" : 15,
#    "universal tags" : ["sadtrombone"],
#    "properties" : {
#        "Cincinnati.com - Homefront" : {
#            "tags" : ["city:cincinnati","state:ohio"]
#        },
#        "FTW_Homefront_GoogleTest" : {
#            "tags" : ["usat","sports"]
#        },
#        "AZCentral.com - Homefront" : {
#            "tags" : []
#        }
# }

datadog_monitor 'keynote' do
  instances []
end

template '/opt/datadog-agent/agent/checks.d/keynote.py' do
	action :create
	owner 'dd-agent'
	source 'keynote.py.erb'
end


