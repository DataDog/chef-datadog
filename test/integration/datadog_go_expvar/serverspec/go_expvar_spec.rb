# Encoding: utf-8
require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/go_expvar.yaml')

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
          'expvar_url' => "http://localhost:8080/debug/vars",
          'tags' => [
              "application:my_go_app"
           ],
          'metrics' => [
            {
              'path' => 'test_metric_name_1', 'alias' => 'go_expvar.test_metric_name_1', 'type' => 'gauge'
            },
            {
              'path' => 'test_metric_name_2', 'alias' => 'go_expvar.test_metric_name_2', 'type' => 'rate', 'tags' => ["category:customtag1", "customtag2"]
            }
          ]
        } 
      ],
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
