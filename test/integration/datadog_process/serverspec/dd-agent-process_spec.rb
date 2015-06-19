# Encoding: utf-8
require 'json_spec'
require_relative '../../../kitchen/data/spec_helper'
require 'yaml'

set :path, '/sbin:/usr/local/sbin:$PATH' unless os[:family] == 'windows'

PROCESS_CONFIG = File.join(@agent_config_dir, 'conf.d/process.yaml')

describe service(@agent_service_name) do
  it { should be_running }
end

describe file(PROCESS_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(PROCESS_CONFIG)

    expected = {
      'instances' => [
        {
          'name' => 'pidname',
          'exact_match' => false,
          'ignore_denied_access' => true,
          'tags' => ['env:test', 'appname:somename'],
          'search_string' => ['somepid', 'pidname']
        }
      ],
      'init_config' => nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
