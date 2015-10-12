# Encoding: utf-8
require 'json_spec'
require 'serverspec'
require 'yaml'

set :backend, :exec
set :path, '/sbin:/usr/local/sbin:$PATH'

JMX_CONFIG = '/etc/dd-agent/conf.d/jmx.yaml'

describe service('datadog-agent') do
  it { should be_running }
end

describe file(JMX_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(JMX_CONFIG)

    EXPECTED = {
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
                  'attribute2' =>  { 'metric_type' => 'gauge', 'alias' => 'jmx.my2ndattribute' }
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
    }

    expect(generated.to_json).to be_json_eql EXPECTED.to_json
  end
end
