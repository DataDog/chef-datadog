# Encoding: utf-8

require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/mesos_master.d/conf.yaml')

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
          url: 'localhost:5050',
          timeout: 8,
          tags: ['master', 'tata']
        }
      ],
      'logs' => nil,
      init_config: {
        default_timeout: 10
      }
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
