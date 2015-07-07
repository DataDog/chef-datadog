require 'spec_helper'

describe package(@agent_package_name) do
  it { should be_installed }
end

describe service(@agent_service_name) do
  it { should be_running }
end

describe command('/etc/init.d/datadog-agent info'), :if => os[:family] != 'windows' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'OK' }
  its(:stdout) { should_not contain 'ERROR' }
end
