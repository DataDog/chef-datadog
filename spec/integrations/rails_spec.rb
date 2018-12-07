describe 'datadog::rails' do
  expected_yaml = <<-EOF
    logs: ~
    init_config:

    instances:
        tags:
        - mytag
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.set['datadog'] = {
        api_key: 'someapikey',
        rails: {
          instances: [
            {
              tags: ['mytag']
            }
         ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('rails') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/dd-agent/conf.d/rails.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
