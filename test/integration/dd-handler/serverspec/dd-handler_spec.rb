require_relative '../../../kitchen/data/spec_helper'

set :path, '/sbin:/usr/local/sbin:$PATH' unless os[:family] == 'windows'

# the be_installed.by('gem') check is not implemented for Windows as of v2.24 of Serverspec
describe package('chef-handler-datadog'), :if => os[:family] != 'windows' do
  it { should be_installed.by('gem') }
end
