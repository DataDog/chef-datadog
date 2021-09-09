describe 'datadog::etcd' do
  expected_yaml = <<-EOF
    logs: ~
    instances:
    - url: localhost
      ssl_keyfile: key_path
      ssl_certfile: cert_path
      ssl_cert_validation: true
      ssl_ca_certs: ca_path
      tags:
      - mytag
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
        etcd: {
          instances: [
            {
              url: 'localhost',
              ssl_keyfile: 'key_path',
              ssl_certfile: 'cert_path',
              ssl_cert_validation: true,
              ssl_ca_certs: 'ca_path',
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

  it { is_expected.to add_datadog_monitor('etcd') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/etcd.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
