require 'serverspec'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

describe package('chef-handler-datadog') do
  it { should be_installed.by('gem') }
end
