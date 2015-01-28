# Encoding: utf-8
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = '/etc/dd-agent/conf.d/http_check.yaml'

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
          'name' => 'test',
          'url' => 'http://localhost/'
        },
        {
          'name' => 'test with notify',
          'url' => 'http://localhost/',
          'notify' => [
            'user2@example.com',
            'pagerduty2'
          ]
        }
      ],
      'init_config' => {
        'notify' => [
          'user1@example.com',
          'pagerduty1'
        ]
      }
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
