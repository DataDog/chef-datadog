include_recipe 'datadog::dd-agent'

# see example configuration file here:
# https://github.com/DataDog/integrations-core/blob/master/snmp/conf.yaml.example

# Example 1 - Optionally a MIBS folder is configured in the init_config
# SNMP v1 - v2
# node['datadog']['snmp'] =
# {
#  "init_config": {
#    "mibs_folder": "/path/to/your/mibs/folder",
#    "ignore_nonincreasing_oid": false
#  },
#  "instances": [
#    {
#      "ip_address": "localhost",
#      "port": 161,
#      "community_string": "public",
#      "snmp_version": 1,
#      "timeout": 1,
#      "retries": 5,
#      "enforce_mib_constraints": true,
#      "tags": [
#        "optional_tag_2"
#      ],
#      "metrics": [
#        {
#          "MIB": "UDP-MIB",
#          "symbol": "udpInDatagrams"
#        },
#        {
#          "MIB": "TCP-MIB",
#          "symbol": "tcpActiveOpens"
#        },
#        {
#          "OID": "1.3.6.1.2.1.6.5",
#          "name": "tcpPassiveOpens"
#        },
#        {
#          "OID": "1.3.6.1.2.1.6.5",
#          "metric_tags": [
#          "TCP"
#          ]
#        },
#        {
#          "OID": "1.3.6.1.4.1.3375.2.1.1.2.1.8.0",
#          "name": "F5_TotalCurrentConnections",
#          "forced_type": "gauge"
#        },
#        {
#          "MIB": "IF-MIB",
#          "table": "ifTable",
#          "symbols": [
#            "ifInOctets",
#            "ifOutOctets"
#          ],
#            {
#            "tag": "interface",
#              "column": "ifDescr"
#            }
#      {
#          "MIB": "IP-MIB",
#          "table": "ipSystemStatsTable",
#          "symbols": [
#            "ipSystemStatsInReceives"
#          ],
#          "metric_tags": [
#            {
#              "tag": "ipversion",
#              "index": 1
#            }
#          ]
#        }
#      ]
#    }
#  ]
# }

# Example 2 - MIBS folder is not configured in init_config
# SNMP v3
# node['datadog']['snmp'] =
# {
#  "instances": [
#    {
#      "ip_address": "192.168.34.10",
#      "port": 161,
#      "user": "user",
#      "authKey": "password",
#      "privKey": "private_key",
#      "authProtocol": "authProtocol",
#      "privProtocol": "privProtocol",
#      "timeout": 1,
#      "retries": 5,
#      "tags": [
#        "optional_tag_1",
#        "optional_tag_2"
#      ],
#      "metrics": [
#        {
#          "MIB": "UDP-MIB",
#          "symbol": "udpInDatagrams"
#        },
#        {
#          "MIB": "TCP-MIB",
#          "symbol": "tcpActiveOpens"
#        }
#      ]
#    }
#  ]
# }

datadog_monitor 'snmp' do
  init_config node['datadog']['snmp']['init_config']
  instances node['datadog']['snmp']['instances']
  logs node['datadog']['snmp']['logs']
end
