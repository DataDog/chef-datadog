# Encoding: utf-8

require 'spec_helper'

JMX_CONFIG = File.join(@agent_config_dir, 'conf.d/jmx.d/conf.yaml')

describe service(@agent_service_name) do
  it { should be_running }
end

describe file(JMX_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(JMX_CONFIG)

    EXPECTED = {
      'logs' => nil,
      'init_config' => nil,
      'instances' => [
        {
          'conf' => [
            {
              'include' => {
                'domain' => 'my_domain',
                'bean' => ['my_bean', 'my_second_bean'],
                'attribute' => {
                  'attribute1' => { 'metric_type' => 'counter', 'alias' => 'jmx.my_metric_name' },
                  'attribute2' => { 'metric_type' => 'gauge', 'alias' => 'jmx.my2ndattribute' }
                }
              }
            },
            {
              'include' => { 'domain' => '2nd_domain' },
              'exclude' => { 'bean' => ['excluded_bean'] }
            },
            {
              'include' => { 'domain_regex' => 'regex_on_domain' },
              'exclude' => { 'bean_regex' => ['regex_on_excluded_bean'] }
            }
          ],
          'host' => 'localhost',
          'name' => 'jmx_instance',
          'password' => 'somepass',
          'port' => 7199,
          'tags' => {
            'env' => 'stage',
            'newTag' => 'test'
          },
          'user' => 'someuser'
        }
      ]
    }.freeze

    expect(generated.to_json).to be_json_eql EXPECTED.to_json
  end
end
