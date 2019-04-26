include_recipe 'datadog::dd-agent'

# Import cacti data
#
# Assuming you have 1 cacti server
# you need to set up the following attributes.
#
# The `rrd_whitelist` is a path to a text file that has a list of patterns,
# one per line, that should be fetched. If no whitelist is specified, all
# metrics will be fetched, which may be an expensive operation.
# We recommand that you set up a white list.
#
# The `field_names` is an optional parameter to specify which field_names
# should be used to determine if a device is a real device. You can let it
# commented out as the default values should satisfy your needs.
# You can run the following query to determine your field names:
#       SELECT
#            h.hostname as hostname,
#            hsc.field_value as device_name,
#            dt.data_source_path as rrd_path,
#            hsc.field_name as field_name
#        FROM data_local dl
#            JOIN host h on dl.host_id = h.id
#            JOIN data_template_data dt on dt.local_data_id = dl.id
#            LEFT JOIN host_snmp_cache hsc on h.id = hsc.host_id
#                AND dl.snmp_index = hsc.snmp_index
#        WHERE dt.data_source_path IS NOT NULL
#        AND dt.data_source_path != ''
#
# node.datadog.cacti.instances = [
#                                 {
#                                  mysql_host: 'localhost',
#                                  mysql_user: 'cacti',
#                                  mysql_password: 'secret',
#                                  rrd_path: '/path/to/rrd/rra',
#                                  rrd_whitelist: '/path/to/rrd_whitelist.txt',
#                                  field_names: ['dskDevice', 'ifIndex', 'ifName']
#                                 }
#                                ]

datadog_monitor 'cacti' do
  instances node['datadog']['cacti']['instances']
  logs node['datadog']['cacti']['logs']
  action :add
  notifies :restart, 'service[datadog-agent]' if node['datadog']['agent_start']
end
