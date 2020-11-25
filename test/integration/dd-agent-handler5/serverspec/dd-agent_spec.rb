require 'spec_helper'

describe package(@agent_package_name) do
  it { should be_installed }
end

describe service(@agent_service_name) do
  it { should be_running }
end

describe command('/etc/init.d/datadog-agent info | grep -v "API Key is invalid"'), :if => os[:family] != 'windows' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'OK' }
  its(:stdout) { should_not contain 'ERROR' }
end

# The new APT key is imported
describe command('apt-key list'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain '382E94DE' }
end

# The new RPM key is imported
describe command('rpm -q gpg-pubkey-e09422b3'), :if => os[:family] == 'redhat' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'gpg-pubkey-e09422b3' }
end
