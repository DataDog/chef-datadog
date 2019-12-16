# Encoding: utf-8

require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/cacti.d/conf.yaml')

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
          field_names: ['ifIndex', 'dskDevice', 'ifName'],
          mysql_host: 'localhost',
          mysql_password: 'mysql_read_only_password',
          mysql_user: 'mysql_read_only',
          rrd_path: '/path/to/cacti/rra',
          rrd_whitelist: '/path/to/rrd_whitelist.txt'
        }
      ],
      'logs' => nil,
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
