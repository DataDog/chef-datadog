# Encoding: utf-8

require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe service('datadog-agent') do
  it { should be_running }
end

# Checks that it's installed properly and with the good version
describe command('/opt/datadog-agent/bin/agent/agent integration show datadog-aerospike') do
  its(:stdout) { should match /Package datadog-aerospike:\nInstalled version:/ }
end
