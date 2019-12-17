# Encoding: utf-8

require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/twemproxy.d/conf.yaml')

describe service(@agent_service_name) do
  it { should be_running }
end

describe file(AGENT_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(AGENT_CONFIG)

    expected = {
      instances: [
        {
          url: 'http://localhost:22222'
        }
      ],
      'logs' => nil,
      init_config: {}
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end

  describe package('dd-check-twemproxy') do
    it { should be_installed.with_version('0.1.0-1') }
  end
end
