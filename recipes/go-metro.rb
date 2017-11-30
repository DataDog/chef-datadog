include_recipe 'datadog::dd-agent'

# Go-Metro (TCP RTT) Integration: Passively monitor TCP Round Trip Time
# between the monitored host and others nodes on the network

# Recommended default init_config:
# (these are set in the go-metro attributes file in this cookbook)
# node['datadog']['go-metro']['init_config'] = {
#   'snaplen' => 512,
#   'idle_ttl' => 300,
#   'exp_ttl' => 60,
#   'statsd_ip' => '127.0.0.1',
#   'statsd_port' => 8125,
#   'log_to_file' => true,
#   'log_level' => 'info'
# }

# Assuming you want to monitor connections to
# 10.0.0.1, 10.0.0.2, 10.0.0.3, and app.datadoghq.com from eth0,
# create an instance configuration like this:
# node['datadog']['go-metro']['instances'] = [
#   {
#     'interface' => 'eth0',
#     'tags' => [
#       'env:prod'
#     ],
#     'ips' => [
#       '10.0.0.1',
#       '10.0.0.2',
#       '10.0.0.3'
#     ],
#     'hosts' => [
#       'app.datadoghq.com'
#     ]
#   }
# ]

####
# At the time of writing, the Go-Metro (TCP Round Trip Time) integration
# is only available as part of the 64-bit DEB and RPM agent distribution
#
# Bail if we're not 64-bit or not linux
if node['kernel']['machine'] != 'x86_64' || node['os'] != 'linux'
  Chef::Log.fatal('The Go-Metro (TCP RTT) integration is only available')
  Chef::Log.fatal('as part of the 64-bit DEB and RPM agent distribution')
  if node['os'] == 'linux'
    Chef::Log.fatal(
      "And Chef thinks this machine is #{node['kernel']['machine']}", \
      "not 'x86_64'"
    )
  else
    Chef::Log.fatal(
      "And Chef thinks this machine is #{node['os']}, not 'linux'"
    )
  end
  raise
end

# install desired package for libcap
# This implementation allows you to set any valid package resourece property
# as an attribute underneath node['datadog']['go-metro']['libcap-package']
package 'libcap' do
  # handle scenario when entire attribute is nil
  unless node['datadog']['go-metro']['libcap_package'].nil?
    # send each attribute as a property to the resource
    node['datadog']['go-metro']['libcap_package'].each do |prop, value|
      send(prop.to_sym, value) unless value.nil?
    end
  end
end

# add cap_net_raw+ep to the go-metro binary
execute 'setcap go-metro' do
  command 'setcap cap_net_raw+ep /opt/datadog-agent/bin/go-metro'
  not_if 'setcap -v cap_net_raw+ep /opt/datadog-agent/bin/go-metro'
end

datadog_monitor 'go-metro' do
  init_config node['datadog']['go-metro']['init_config']
  instances node['datadog']['go-metro']['instances']
  logs node['datadog']['go-metro']['logs']
end
