describe 'datadog::windows_service'  do
	expected_yaml = <<-EOF
		init_config:

		instances:
		- host: REMOTEHOSTNAME
		  username: REMOTEHOSTNAME\thomas
		  password: secretpw
		  services:
		    - RemoteService
	EOF

  cached(:chef_run) do
  	ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.automatic['languages'] = { python: { version: '2.7.2' } }

      node.set['datadog'] = {
      	api_key: 'someapikey',
        instances: [{
        	username: 'REMOTEHOSTNAME\\thomas',
        	services: [
        	  'RemoteService'
        	  ],
        	host: 'REMOTEHOSTNAME',
        	password: 'secretpw'
        	}
        ]
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::datadog-agent') }

  it { is_expected.to add_datadog_monitor('windows_service') }

  it 'renders expected YAML config file' do
    expect(chef_run).to render_file('/etc/dd-agent/conf.d/windows_serviceyaml').with_content { |content|
      expect(YAML.load(content).to_json).to be_json_eql(YAML.load(expected_yaml).to_json)
    }
  end
end
