require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/gearmand.d/conf.yaml')

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
          'server' => '127.0.0.1',
          'port' => '4730',
          'tasks' => [
            'TASK_1',
            'TASK_2',
          ],
          'tags' => [
            '<KEY_1>:<VALUE_1>',
            '<KEY_2>:<VALUE_2>'
          ],
          'service' => '<SERVICE>',
          # Defaults to 15 if not set
          'min_collection_interval' => 60,
          # Defaults to false if not set
          'empty_default_hostname' => true,
          'metric_patterns' => {
            'include' => [
              '<INCLUDE_REGEX>'
            ],
            'exclude' => [
              '<EXCLUDE_REGEX>'
            ]
          }
        }
      ],
      'logs' => nil,
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
