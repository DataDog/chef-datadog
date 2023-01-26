# Copyright:: 2011-Present, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'spec_helper'

@agent_package_name = 'datadog-iot-agent'

describe package(@agent_package_name) do
  it { should be_installed }
end

describe service(@agent_service_name) do
  it { should be_running }
end

describe command('/opt/datadog-agent/bin/agent/agent status | grep -v "Instance ID"'), :if => os[:family] != 'windows' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain '[OK]' }
  its(:stdout) { should_not contain 'ERROR' }
end

# The new APT keys are imported
describe command('apt-key list'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain '382E94DE' }
  its(:stdout) { should contain 'F14F620E' }
end

# The new RPM keys are imported
describe command('rpm -q gpg-pubkey-e09422b3'), :if => os[:family] == 'redhat' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'gpg-pubkey-e09422b3' }
end

describe command('rpm -q gpg-pubkey-fd4bf915'), :if => os[:family] == 'redhat' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'gpg-pubkey-fd4bf915' }
end
