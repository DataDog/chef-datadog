# Encoding: utf-8

require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/rabbitmq.d/conf.yaml')

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
          'rabbitmq_api_url' => 'http://localhost:15672/api/',
          'rabbitmq_user' => 'someuser',
          'rabbitmq_pass' => 'somepassword',
          'ssl_verify' => true,
          'tag_families' => false,
          'max_detailed_exchanges' => 300,
          'max_detailed_queues' => 300,
          'tags' => ['tag1', 'tag2'],
          'nodes' => ['node1', 'node2'],
          'nodes_regexes' => ['node3.*', 'node4.*'],
          'vhosts' => ['vhost1', 'vhost2'],
          'queues' => ['queue1', 'queue2'],
          'queues_regexes' => ['queue3.*', 'queue4.*'],
          'timeout' => 30
        }
      ],
      'logs' => nil,
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
