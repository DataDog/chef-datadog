# Copyright:: 2011-Present, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
