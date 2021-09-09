describe 'datadog::postfix' do
  expected_yaml = <<-EOF
    logs: ~
    instances:
    - directory: /var/spool/postfix
      queues:
      - incoming
      - active
      - deferred
      tags:
      - prod
      - postfix_core
    - directory: /var/spool/postfix
      queues:
      - bounce
    init_config:
  EOF

  before do
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).and_call_original
    allow_any_instance_of(Chef::Recipe).to receive(:include_recipe).with('sudo')
    allow_any_instance_of(Chef::Recipe).to receive(:sudo)
  end

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['datadog_monitor']
    ) do |node|
      node.automatic['languages'] = { python: { version: '2.7.2' } }

      node.normal['datadog'] = {
        api_key: 'someapikey',
        postfix: {
          instances: [
            {
              directory: '/var/spool/postfix',
              queues: ['incoming', 'active', 'deferred'],
              tags: ['prod', 'postfix_core']
            },
            {
              directory: '/var/spool/postfix',
              queues: ['bounce']
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('postfix') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/postfix.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
