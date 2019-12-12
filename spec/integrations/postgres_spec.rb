describe 'datadog::postgres' do
  expected_yaml = <<-EOF
    logs: ~
    instances:
    - host: localhost
      port: 5432
      ssl: true
      username: datadog
      password: somepass
      dbname: my_database
      tags:
      - spec
      relations:
      - apple_table
      - orange_table
      collect_function_metrics: true
      custom_metrics:
        - descriptors:
            - ['query_column1', 'tag1']
            - ['query_column2', 'tag2']
          metrics:
            field1:
              - postgresql.field1
              - GAUGE
            field2:
              - postgresql.field2
              - MONOTONIC
          query: SELECT query_column1, query_column2, %s FROM foo
          relation: true
        - descriptors:
            - ['three', 'three']
            - ['four', 'four']
          metrics:
            field3:
              - postgresql.field3
              - GAUGE
            field4:
              - postgresql.field4
              - MONOTONIC
          query: SELECT three, four, %s FROM foo
          relation: false
    init_config:
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['datadog_monitor']
    ) do |node|
      node.automatic['languages'] = { python: { version: '2.7.2' } }

      node.normal['datadog'] = {
        api_key: 'someapikey',
        postgres: {
          instances: [
            {
              collect_function_metrics: true,
              dbname: 'my_database',
              password: 'somepass',
              port: 5432,
              relations: ['apple_table', 'orange_table'],
              server: 'localhost',
              ssl: true,
              tags: ['spec'],
              username: 'datadog',
              'custom_metrics' => [
                {
                  'descriptors' => [
                    ['query_column1', 'tag1'],
                    ['query_column2', 'tag2']
                  ],
                  'metrics' => {
                    'field1' => ['postgresql.field1', 'GAUGE'],
                    'field2' => ['postgresql.field2', 'MONOTONIC']
                  },
                  'query' => 'SELECT query_column1, query_column2, %s FROM foo',
                  'relation' => true
                },
                {
                  'descriptors' => [
                    ['three', 'three'],
                    ['four', 'four']
                  ],
                  'metrics' => {
                    'field3' => ['postgresql.field3', 'GAUGE'],
                    'field4' => ['postgresql.field4', 'MONOTONIC']
                  },
                  'query' => 'SELECT three, four, %s FROM foo',
                  'relation' => false
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

  it { is_expected.to add_datadog_monitor('postgres') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/postgres.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end

describe 'datadog::postgres' do
  context 'default settings' do
    expected_yaml = <<-EOF
      logs: ~
      instances:
      - host: localhost
        port: 5432
        dbname: default_settings
      init_config:
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.normal['datadog'] = {
          api_key: 'someapikey',
          postgres: {
            instances: [
              {
                dbname: 'default_settings',
                server: 'localhost'
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('postgres') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/postgres.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end

  context 'default settings with a domain socket' do
    expected_yaml = <<-EOF
      logs: ~
      instances:
      - host: /var/run/postgresql/.s.PGSQL.5432
        dbname: default_settings
      init_config:
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.normal['datadog'] = {
          api_key: 'someapikey',
          postgres: {
            instances: [
              {
                dbname: 'default_settings',
                server: '/var/run/postgresql/.s.PGSQL.5432'
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    subject { chef_run }

    it_behaves_like 'datadog-agent'

    it { is_expected.to include_recipe('datadog::dd-agent') }

    it { is_expected.to add_datadog_monitor('postgres') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/postgres.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end

  context 'relations' do
    expected_yaml = <<-EOF
      logs: ~
      instances:
      - host: localhost
        port: 5432
        dbname: relations_settings
        relations:
          - my_table
          - my_other_table
          - relation_name: another_table
            schemas:
            - public
            - prod
      init_config:
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.normal['datadog'] = {
          api_key: 'someapikey',
          postgres: {
            instances: [
              {
                dbname: 'relations_settings',
                host: 'localhost',
                relations: [
                  'my_table',
                  'my_other_table',
                  relation_name: 'another_table', schemas: ['public', 'prod']
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

    it { is_expected.to add_datadog_monitor('postgres') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/postgres.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end

  context 'descriptors' do
    expected_yaml = <<-EOF
      logs: ~
      instances:
      - host: localhost
        port: 5432
        dbname: descriptors_settings
        custom_metrics:
          - descriptors:
              - ['query_column1', 'tag1']
              - ['query_column2', 'tag2']
            metrics:
              field1:
                - postgresql.field1
                - GAUGE
              field2:
                - postgresql.field2
                - MONOTONIC
            query: SELECT query_column1, query_column2, %s FROM foo
            relation: true
          - descriptors: []
            metrics:
              field3:
                - postgresql.field3
                - GAUGE
              field4:
                - postgresql.field4
                - MONOTONIC
            query: SELECT three, four, %s FROM foo
            relation: false
      init_config:
    EOF

    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '16.04',
        step_into: ['datadog_monitor']
      ) do |node|
        node.automatic['languages'] = { python: { version: '2.7.2' } }

        node.normal['datadog'] = {
          api_key: 'someapikey',
          postgres: {
            instances: [
              {
                dbname: 'descriptors_settings',
                host: 'localhost',
                'custom_metrics' => [
                  {
                    'descriptors' => [
                      ['query_column1', 'tag1'],
                      ['query_column2', 'tag2']
                    ],
                    'metrics' => {
                      'field1' => ['postgresql.field1', 'GAUGE'],
                      'field2' => ['postgresql.field2', 'MONOTONIC']
                    },
                    'query' => 'SELECT query_column1, query_column2, %s FROM foo',
                    'relation' => true
                  },
                  {
                    'descriptors' => [],
                    'metrics' => {
                      'field3' => ['postgresql.field3', 'GAUGE'],
                      'field4' => ['postgresql.field4', 'MONOTONIC']
                    },
                    'query' => 'SELECT three, four, %s FROM foo',
                    'relation' => false
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

    it { is_expected.to add_datadog_monitor('postgres') }

    it 'renders expected YAML config file' do
      expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/postgres.d/conf.yaml').with_content { |content|
        expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
      })
    end
  end
end
