describe 'datadog::snmp' do
  context 'config snmp v1 - v2' do
    expected_yaml = <<-EOF
    init_config:
      mibs_folder: '/path/to/your/mibs/folder'
      ignore_nonincreasing_oid: false
    instances:
    - ip_address: localhost
      port: 161
      community_string: public
      snmp_version: 1
      timeout: 1
      retries: 5
      enforce_mib_constraints: true
      tags:
      - optional_tag_1
      - optional_tag_2
      metrics:
      - MIB: UDP-MIB
        symbol: udpInDatagrams
      - MIB: TCP-MIB
        symbol: tcpActiveOpens
      - OID: 1.3.6.1.2.1.6.5
        name: tcpPassiveOpens
      - OID: 1.3.6.1.2.1.6.5
        name: tcpPassiveOpens
        metric_tags:
        - TCP
      - OID: 1.3.6.1.4.1.3375.2.1.1.2.1.8.0
        name: F5_TotalCurrentConnections
        forced_type: gauge
      - MIB: IF-MIB
        table: ifTable
        symbols:
        - ifInOctets
        - ifOutOctets
        metric_tags:
        - tag: interface
          column: ifDescr
      - MIB: IP-MIB
        table: ipSystemStatsTable
        symbols:
        - ipSystemStatsInReceives
        metric_tags:
        - tag: ipversion
          index: 1
    logs: ~
  EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
        node.normal['datadog'] = {
          api_key: 'someapikey',
          snmp: {
            init_config: {
              mibs_folder: '/path/to/your/mibs/folder',
              ignore_nonincreasing_oid: false
            },
            instances: [
              {
                ip_address: 'localhost',
                port: 161,
                community_string: 'public',
                snmp_version: 1,
                timeout: 1,
                retries: 5,
                enforce_mib_constraints: true,
                tags: [
                  'optional_tag_1',
                  'optional_tag_2'
                ],
                metrics: [
                  {
                    MIB: 'UDP-MIB',
                    symbol: 'udpInDatagrams'
                  },
                  {
                    MIB: 'TCP-MIB',
                    symbol: 'tcpActiveOpens'
                  },
                  {
                    OID: '1.3.6.1.2.1.6.5',
                    name: 'tcpPassiveOpens'
                  },
                  {
                    OID: '1.3.6.1.2.1.6.5',
                    name: 'tcpPassiveOpens',
                    metric_tags: [
                      'TCP'
                    ]
                  },
                  {
                    OID: '1.3.6.1.4.1.3375.2.1.1.2.1.8.0',
                    name: 'F5_TotalCurrentConnections',
                    forced_type: 'gauge'
                  },
                  {
                    MIB: 'IF-MIB',
                    table: 'ifTable',
                    symbols: [
                      'ifInOctets',
                      'ifOutOctets'
                    ],
                    metric_tags: [
                      {
                        tag: 'interface',
                        column: 'ifDescr'
                      }
                    ]
                  },
                  {
                    MIB: 'IP-MIB',
                    table: 'ipSystemStatsTable',
                    symbols: [
                      'ipSystemStatsInReceives'
                    ],
                    metric_tags: [
                      {
                        tag: 'ipversion',
                        index: 1
                      }
                    ]
                  }
                ]
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('snmp') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/snmp.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end

describe 'datadog::snmp' do
  context 'config snmp v3' do
    expected_yaml = <<-EOF
    init_config: ~

    instances:
    - ip_address: 192.168.34.10
      port: 161
      user: user
      authKey: password
      privKey: private_key
      authProtocol: authProtocol
      privProtocol: privProtocol
      timeout: 1
      retries: 5
      tags:
        - optional_tag_1
        - optional_tag_2
      metrics:
        - MIB: UDP-MIB
          symbol: udpInDatagrams
        - MIB: TCP-MIB
          symbol: tcpActiveOpens
    logs: ~
  EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
        node.normal['datadog'] = {
          api_key: 'someapikey',
          snmp: {
            instances: [
              {
                ip_address: '192.168.34.10',
                port: 161,
                user: 'user',
                authKey: 'password',
                privKey: 'private_key',
                authProtocol: 'authProtocol',
                privProtocol: 'privProtocol',
                timeout: 1,
                retries: 5,
                tags: [
                  'optional_tag_1',
                  'optional_tag_2'
                ],
                metrics: [
                  {
                    MIB: 'UDP-MIB',
                    symbol: 'udpInDatagrams'
                  },
                  {
                    MIB: 'TCP-MIB',
                    symbol: 'tcpActiveOpens'
                  }
                ]
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('snmp') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/snmp.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
