# Encoding: utf-8

require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/elastic.d/conf.yaml')

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
          'url' => 'http://localhost:9200',
          'username' => 'someuser',
          'password' => 'somepass',
          'is_external' => false,
          'pshard_stats' => true,
          'index_stats' => true,
          'shard_level_metrics' => true,
          'tags' => ['kitchen', 'sink']
        }
      ],
      'logs' => nil,
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
