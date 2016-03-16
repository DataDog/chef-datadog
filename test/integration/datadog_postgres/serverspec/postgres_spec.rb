# Encoding: utf-8
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

AGENT_CONFIG = '/etc/dd-agent/conf.d/postgres.yaml'

describe service('datadog-agent') do
  it { should be_running }
end

describe file(AGENT_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(AGENT_CONFIG)

    expected = {
      instances: [
        {
          host: 'localhost',
          port: 5432,
          username: 'john',
          password: 'doe',
          tags: ['toto', 'tata'],
          dbname: 'dbname',
          ssl: true,
          custom_metrics: [{
            descriptors: ['one', 'two'],
            metrics: {
              field1: ['postgresql.field1', 'GAUGE'],
              field2: ['postgresql.field2', 'MONOTONIC']
            },
            query: 'SELECT one, two, %s FROM foo',
            relation: true
          }]
        }
      ],
      init_config: nil
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
