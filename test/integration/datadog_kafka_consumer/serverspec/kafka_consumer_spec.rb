# Encoding: utf-8
require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/kafka_consumer.d/conf.yaml')

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
          :kafka_connect_str => 'localhost:19092',
          :consumer_groups => {
            :my_consumer => {
              :my_topic => [0,1,4,12]
            }
          },
          :monitor_unlisted_consumer_groups => 'false',
          :zk_connect_str => 'localhost:2181',
          :zk_prefix => '/0.8'
        }
      ],
      'logs' => nil,
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
