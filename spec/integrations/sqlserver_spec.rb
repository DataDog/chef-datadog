describe 'datadog::sqlserver' do
  context 'config 1' do
    expected_yaml = <<-EOF
    logs: ~
    init_config:
      custom_metrics:
        - name: sqlserver.clr.execution
          counter_name: CLR execution
        - name: sqlserver.exec.in_progress
          counter_name: OLEDB calls
          instance_name: Cumulative execution time (ms) per second
        - name: sqlserver.db.commit_table_entries
          counter_name: Log Flushes/sec
          instance_name: ALL
          tag_by: db
    instances:
      - host: fakehostname,1433
        connector: odbc
        driver: SQL Server
        username: fake_user
        password: bogus_pw
        command_timeout: 30
        database: fake_db_name
        tags:
          - test_tag_name
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
          sqlserver: {
            instances: [
              {
                host: 'fakehostname,1433',
                connector: 'odbc',
                driver: 'SQL Server',
                username: 'fake_user',
                password: 'bogus_pw',
                command_timeout: 30,
                database: 'fake_db_name',
                tags: ['test_tag_name']
              }
            ],
            init_config: {
              custom_metrics: [
                {
                  name: 'sqlserver.clr.execution',
                  counter_name: 'CLR execution'
                },
                {
                  name: 'sqlserver.exec.in_progress',
                  counter_name: 'OLEDB calls',
                  instance_name: 'Cumulative execution time (ms) per second'
                },
                {
                  name: 'sqlserver.db.commit_table_entries',
                  counter_name: 'Log Flushes/sec',
                  instance_name: 'ALL',
                  tag_by: 'db'
                }
              ]
            }
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('sqlserver') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/sqlserver.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end

describe 'datadog::sqlserver' do
  context 'config 2' do
    expected_yaml = <<-EOF
    init_config: ~
    logs: ~

    instances:
      - host: fakehostname,1433
        connector: odbc
        driver: SQL Server
        username: fake_user
        password: bogus_pw
        command_timeout: 30
        database: fake_db_name
        tags:
          - test_tag_name
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
          sqlserver: {
            instances: [
              {
                host: 'fakehostname,1433',
                connector: 'odbc',
                driver: 'SQL Server',
                username: 'fake_user',
                password: 'bogus_pw',
                command_timeout: 30,
                database: 'fake_db_name',
                tags: ['test_tag_name']
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('sqlserver') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/sqlserver.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
