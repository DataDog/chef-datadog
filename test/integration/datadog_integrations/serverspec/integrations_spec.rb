# Encoding: utf-8
require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/twemproxy.yaml')

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
      init_config: {}
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end

  if @agent_check_dir
    AGENT_CHECK = File.join(@agent_check_dir, 'twemproxy.py')
    describe file(AGENT_CHECK) do
      it { should be_a_file }
    end
  end
end
