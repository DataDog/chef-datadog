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

describe package(@agent_package_name) do
  it { should be_installed }
end

describe service(@agent_service_name) do
  it { should be_running }
end

# On Linux kernel >= 5.5, Agent 5 disk check fails because of old psutil version, which doesn't have fix
# https://github.com/giampaolo/psutil/commit/2e0952e939d6ab517449314876d8d3488ba5b98b
describe command('/etc/init.d/datadog-agent info | grep -v "API Key is invalid" | grep -v "not sure how to interpret line" | egrep -v "Unable to validate API Key. Please try again later"'), :if => os[:family] != 'windows' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'OK' }
  
  it 'dumps full output for debugging before ERROR check' do
    output = subject.stdout
    puts "\n" + "="*80
    puts "FULL DATADOG AGENT INFO OUTPUT (#{output.length} chars)"
    puts "="*80
    puts output
    puts "="*80
    if output.include?('ERROR')
      puts "\nERROR LINES FOUND:"
      output.lines.each_with_index do |line, idx|
        puts "[#{idx + 1}] #{line}" if line.upcase.include?('ERROR')
      end
    end
  end
  
  its(:stdout) { should_not contain 'ERROR' }
end

# The new APT keys are imported
describe command('apt-key list'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain '06462314' }
  its(:stdout) { should contain 'C0962C7D' }
  its(:stdout) { should contain 'F14F620E' }
  its(:stdout) { should contain '382E94DE' }
end

# The new RPM keys are imported
describe command('rpm -q gpg-pubkey-4f09d16b'), :if => os[:family] == 'redhat' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'gpg-pubkey-4f09d16b' }
end

describe command('rpm -q gpg-pubkey-b01082d3'), :if => os[:family] == 'redhat' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'gpg-pubkey-b01082d3' }
end

describe command('rpm -q gpg-pubkey-fd4bf915'), :if => os[:family] == 'redhat' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'gpg-pubkey-fd4bf915' }
end

describe command('rpm -q gpg-pubkey-e09422b3'), :if => os[:family] == 'redhat' do
  its(:exit_status) { should eq 1 }
end
