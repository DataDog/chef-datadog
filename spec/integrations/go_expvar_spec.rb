describe 'datadog::go_expvar' do
  expected_yaml = <<-EOF
    logs: ~
    init_config: ~
    instances:
    - expvar_url: http://localhost:8080/debug/vars
      tags:
      - application:my_go_app
      metrics:
      - path: test_metric_name_1
        alias: go_expvar.test_metric_name_1
        type: gauge
      - path: test_metric_name_2
        alias: go_expvar.test_metric_name_2
        type: rate
        tags:
        - category:customtag1
        - customtag2
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['datadog_monitor']
    ) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }

      node.normal['datadog'] = {
        'api_key' => 'someapikey',
        'go_expvar' => {
          instances: [
            {
              'expvar_url' => 'http://localhost:8080/debug/vars',
              'tags' => ['application:my_go_app'],
              'metrics' => [
                {
                  'path' => 'test_metric_name_1', 'alias' => 'go_expvar.test_metric_name_1', 'type' => 'gauge'
                },
                {
                  'path' => 'test_metric_name_2', 'alias' => 'go_expvar.test_metric_name_2', 'type' => 'rate', 'tags' => ['category:customtag1', 'customtag2']
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

  it { is_expected.to add_datadog_monitor('go_expvar') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/go_expvar.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
