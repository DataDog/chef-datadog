require 'spec_helper'

# The new RPM key is imported
describe command('rpm -q gpg-pubkey-e09422b3'), :if => os[:family] == 'redhat' do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should contain 'gpg-pubkey-e09422b3' }
end
