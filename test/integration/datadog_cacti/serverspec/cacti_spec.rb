# Encoding: utf-8
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = '/etc/dd-agent/conf.d/cacti.yaml'

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
          field_names: ['ifIndex', 'dskDevice', 'ifName'],
          mysql_host: 'localhost',
          mysql_password: 'mysql_read_only_password',
          mysql_user: 'mysql_read_only',
          rrd_path: '/path/to/cacti/rra',
          rrd_whitelist: '/path/to/rrd_whitelist.txt'
        }
      ],
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
