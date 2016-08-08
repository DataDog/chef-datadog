describe 'datadog::kafka' do
  cached(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }

      node.set['datadog'] = {
        'api_key' => 'someapikey',
        'kafka' => {
          'instances' => [
            {
              'host' => 'localhost',
              'port' => 1234
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('kafka') }

  it 'renders expected YAML config file' do
    expect(chef_run).to render_file('/etc/dd-agent/conf.d/kafka.yaml').with_content { |actual_yaml|
      actual = YAML.load(actual_yaml)
      expect(actual['instances']).to eq(
        [
          {
            'host' => 'localhost',
            'port' => 1234
          }
        ]
      )
    }
  end

  describe 'with optional values specified' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
        node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }

        node.set['datadog'] = {
          'api_key' => 'someapikey',
          'kafka' => {
            'instances' => [
              {
                'host' => 'localhost',
                'port' => 1234,
                'name' => 'chef_spec_name',
                'user' => 'chef_spec_user',
                'password' => 'chef_spec_password',
                'process_name_regex' => 'chef_spec.*',
                'tools_jar_path' => '/chef/spec/tools.jar',
                'java_bin_path' => '/chef/spec/java/bin',
                'trust_store_path' => '/chef/spec/trusts',
                'trust_store_password' => 'chef_spec_ts_password',
                'tags' => {'key' => 'value'}
              }
            ]
          }
        }
      end.converge(described_recipe)
    end

    it 'renders optional values into the config file' do
      expect(chef_run).to render_file('/etc/dd-agent/conf.d/kafka.yaml').with_content { |actual_yaml|
        actual = YAML.load(actual_yaml)
        expect(actual['instances']).to eq(
          [
            {
              'host' => 'localhost',
              'port' => 1234,
              'name' => 'chef_spec_name',
              'user' => 'chef_spec_user',
              'password' => 'chef_spec_password',
              'process_name_regex' => 'chef_spec.*',
              'tools_jar_path' => '/chef/spec/tools.jar',
              'java_bin_path' => '/chef/spec/java/bin',
              'trust_store_path' => '/chef/spec/trusts',
              'trust_store_password' => 'chef_spec_ts_password',
              'tags' => {'key' => 'value'}
            }
          ]
        )
      }
    end
  end
end
