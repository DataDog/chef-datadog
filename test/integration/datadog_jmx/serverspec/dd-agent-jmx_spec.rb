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

    expected = {
      'init_config' => nil,
      'instances' => [
        {
          'conf' => [
            {
              'exclude' => [
                {
                  'domain' => 'evil_domain'
                }
              ],
              'include' => {
                'attribute' => {
                  'bytesReceived' => { 'metric_type' => 'counter', 'alias' => 'tomcat.bytes_rcvd' },
                  'maxThreads' => { 'metric_type' => 'gauge', 'alias' => 'tomcat.threads.max' }
                },
                'bean' => 'tomcat_bean',
                'domain' => 'domain0',
                'type' => 'ThreadPool'
              },
              'include' => {
                'attributes' => [
                  'BloomFilterDiskSpaceUsed',
                  'Capacity'
                ],
                'bean_name' => 'com.datadoghq.test:type=BeanType,tag1=my_bean_name',
                'domain' => 'org.apache.cassandra.db',
                'foo' => 'bar'
              }
            }
          ],
          'extra_key' => 'extra_val',
          'host' => 'localhost',
          'port' => 9999
        }
      ]
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
