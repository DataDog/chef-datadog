# Encoding: utf-8

require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = '/etc/dd-agent/conf.d/ssh_check.yaml'.freeze

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
          'host' => 'localhost',
          'username' => 'root',
          'password' => 'password',
          'add_missing_keys' => false,
          'tags' => ['tag1', 'tag2']
        },
        {
          'host' => 'sftp_server.example.com',
          'username' => 'test',
          'port' => 2323,
          'sftp_check' => true,
          'private_key_file' => '/path/to/key',
          'tags' => ['tag1', 'tag3']
        }
      ],
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
