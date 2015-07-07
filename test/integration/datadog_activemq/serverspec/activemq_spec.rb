# Encoding: utf-8
require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/activemq.yaml')

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
          'host' => 'localhost',
          'port' => 1099,
          'user' => 'someuser',
          'password' => 'somepass'
        }
      ],
      'init_config' => {
        'conf' => [
          {
            'include' => {
              'Type' => 'Queue',
              'attribute' => {
                'AverageEnqueueTime' => {
                  'alias' => 'activemq.queue.avg_enqueue_time',
                  'metric_type' => 'gauge'
                },
                'ConsumerCount' => {
                  'alias' => 'activemq.queue.consumer_count',
                  'metric_type' => 'gauge'
                },
                'ProducerCount' => {
                  'alias' => 'activemq.queue.producer_count',
                  'metric_type' => 'gauge'
                },
                'MaxEnqueueTime' => {
                  'alias' => 'activemq.queue.max_enqueue_time',
                  'metric_type' => 'gauge'
                },
                'MinEnqueueTime' => {
                  'alias' => 'activemq.queue.min_enqueue_time',
                  'metric_type' => 'gauge'
                },
                'MemoryPercentUsage' => {
                  'alias' => 'activemq.queue.memory_pct',
                  'metric_type' => 'gauge'
                },
                'QueueSize' => {
                  'alias' => 'activemq.queue.size',
                  'metric_type' => 'gauge'
                },
                'DequeueCount' => {
                  'alias' => 'activemq.queue.dequeue_count',
                  'metric_type' => 'counter'
                },
                'DispatchCount' => {
                  'alias' => 'activemq.queue.dispatch_count',
                  'metric_type' => 'counter'
                },
                'EnqueueCount' => {
                  'alias' => 'activemq.queue.enqueue_count',
                  'metric_type' => 'counter'
                },
                'ExpiredCount' => {
                  'alias' => 'activemq.queue.expired_count',
                  'metric_type' => 'counter'
                },
                'InFlightCount' => {
                  'alias' => 'activemq.queue.in_flight_count',
                  'metric_type' => 'counter'
                }
              }
            }
          },
          {
            'include' => {
              'Type' => 'Broker',
              'attribute' => {
                'StorePercentUsage' => {
                  'alias' => 'activemq.broker.store_pct',
                  'metric_type' => 'gauge'
                },
                'TempPercentUsage' => {
                  'alias' => 'activemq.broker.temp_pct',
                  'metric_type' => 'gauge'
                },
                'MemoryPercentUsage' => {
                  'alias' => 'activemq.broker.memory_pct',
                  'metric_type' => 'gauge'
                }
              }
            }
          }
        ]
      }
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
