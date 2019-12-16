describe 'datadog::couchbase' do
  expected_yaml = <<-EOF
    logs: ~
    init_config:

    instances:
    - server: http://localhost:8091
      user: Administrator
      password: default
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
        couchbase: {
          instances: [
            {
              server: 'http://localhost:8091',
              username: 'Administrator',
              password: 'default'
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('couchbase') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/couchbase.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
