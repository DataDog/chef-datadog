# Encoding: utf-8

require 'spec_helper'
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/mysql.d/conf.yaml')

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
          'server' => '1.1.1.1',
          'port' => 3307,
          'user' => 'my_username',
          'pass' => 'my_password',
          'sock' => '/path/to/mysql.sock',
          'tags' => ['prod', 'my_app'],
          'options' => {
            'replication' => 0
          },
          'queries' => [
            {
              'type' => 'gauge',
              'field' => 'users_count',
              'metric' => 'my_app.my_users.count',
              'query' => 'SELECT COUNT(1) AS users_count FROM users'
            },
            {
              'type' => 'gauge',
              'field' => 'max_query_time',
              'metric' => 'mysql.performance.max_query_time',
              'query' => "SELECT IFNULL(MAX(TIME), 0) AS max_query_time FROM INFORMATION_SCHEMA.PROCESSLIST WHERE COMMAND != 'Sleep'"
            }
          ]
        }
      ],
      'logs' => nil,
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
