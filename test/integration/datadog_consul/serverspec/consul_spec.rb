require 'spec_helper'
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/consul.d/conf.yaml')

describe service(@agent_service_name) do
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
          'tags' => ['_default'],
        },
      ],
      'logs' => nil,
      'init_config' => nil,
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
