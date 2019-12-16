# Encoding: utf-8

require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/kafka.d/conf.yaml')

describe service(@agent_service_name) do
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
          java_bin_path: '/path/to/java',
          name: 'my_kafka',
          password: 'password',
          port: 9999,
          trust_store_password: 'password',
          trust_store_path: '/path/to/trustStore.jks',
          user: 'username'
        }
      ],
      'logs' => nil,
      init_config: {
        is_jmx: true,
        conf: [
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsBytesOutPerSec"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.net.bytes_out'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsBytesInPerSec"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.net.bytes_in'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsMessagesInPerSec"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.messages_in'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsFailedFetchRequestsPerSec"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.request.fetch.failed'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="BrokerTopicMetrics",name="AllTopicsFailedProduceRequestsPerSec"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.request.produce.failed'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.network"',
              bean: '"kafka.network":type="RequestMetrics",name="Produce-TotalTimeMs"',
              attribute: {
                Mean: {
                  metric_type: 'gauge',
                  alias: 'kafka.request.produce.time.avg'
                },
                '99thPercentile' => {
                  metric_type: 'gauge',
                  alias: 'kafka.request.produce.time.99percentile'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.network"',
              bean: '"kafka.network":type="RequestMetrics",name="Fetch-TotalTimeMs"',
              attribute: {
                Mean: {
                  metric_type: 'gauge',
                  alias: 'kafka.request.fetch.time.avg'
                },
                '99thPercentile' => {
                  metric_type: 'gauge',
                  alias: 'kafka.request.fetch.time.99percentile'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.network"',
              bean: '"kafka.network":type="RequestMetrics",name="UpdateMetadata-TotalTimeMs"',
              attribute: {
                Mean: {
                  metric_type: 'gauge',
                  alias: 'kafka.request.update_metadata.time.avg'
                },
                '99thPercentile' => {
                  metric_type: 'gauge',
                  alias: 'kafka.request.update_metadata.time.99percentile'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.network"',
              bean: '"kafka.network":type="RequestMetrics",name="Metadata-TotalTimeMs"',
              attribute: {
                Mean: {
                  metric_type: 'gauge',
                  alias: 'kafka.request.metadata.time.avg'
                },
                '99thPercentile' => {
                  metric_type: 'gauge',
                  alias: 'kafka.request.metadata.time.99percentile'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.network"',
              bean: '"kafka.network":type="RequestMetrics",name="Offsets-TotalTimeMs"',
              attribute: {
                Mean: {
                  metric_type: 'gauge',
                  alias: 'kafka.request.offsets.time.avg'
                },
                '99thPercentile' => {
                  metric_type: 'gauge',
                  alias: 'kafka.request.offsets.time.99percentile'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="ReplicaManager",name="ISRShrinksPerSec"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.replication.isr_shrinks'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="ReplicaManager",name="ISRExpandsPerSec"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.replication.isr_expands'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="ControllerStats",name="LeaderElectionRateAndTimeMs"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.replication.leader_elections'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.server"',
              bean: '"kafka.server":type="ControllerStats",name="UncleanLeaderElectionsPerSec"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.replication.unclean_leader_elections'
                }
              }
            }
          },
          {
            include: {
              domain: '"kafka.log"',
              bean: '"kafka.log":type="LogFlushStats",name="LogFlushRateAndTimeMs"',
              attribute: {
                MeanRate: {
                  metric_type: 'gauge',
                  alias: 'kafka.log.flush_rate'
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
