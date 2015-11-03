require 'spec_helper'

describe package(@agent_package_name) do
  it { should be_installed }
end

describe service(@agent_service_name) do
  it { should be_running }
end

# verifies that the agent is installed per-machine for windows
describe windows_registry_key('HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\776BC1A520EDC164EBF87A0875775D9C'), :if => os[:family] == 'windows' do
  it { should exist }
end

describe command('/etc/init.d/datadog-agent info'), :if => os[:family] != 'windows' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'OK' }
  its(:stdout) { should_not contain 'ERROR' }
end
