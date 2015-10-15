# Encoding: utf-8
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = '/etc/dd-agent/conf.d/consul.yaml'

describe service('datadog-agent') do
  it { should be_running }
end

describe file(AGENT_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(AGENT_CONFIG)

    expected = {
      'instances' => [
        {
          'url' => 'http://localhost:8500',
          'new_leader_checks' => false,
          'catalog_checks' => false,
          'service_whitelist' => 'consul',
          'tags' => ['_default']
        }
      ],
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
