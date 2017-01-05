describe 'datadog::custom_checks' do
  expected_yaml1 = <<-EOF
    instances:
    - url: 'http://localhost:11111'
    init_config:
      default_timeout: 10
  EOF
  expected_yaml2 = <<-EOF
    instances:
    - url: 'http://localhost:22222'
    init_config:
      default_timeout: 5
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.automatic['languages'] = { python: { version: '2.7.2' } }

      node.set['datadog'] = {
        api_key: 'someapikey',
        custom_checks: {
          custom_check_1: {
            enabled: true,
            cookbook: 'datadog_test'
          },
          custom_check_2: {
            enabled: true,
            cookbook: 'datadog_test',
            source: 'custom_folder/custom_check_2.py'
          },
          custom_check_3: {
            enabled: false,
            cookbook: 'datadog_test'
          }
        },
        custom_check_1: {
          init_config: {
            default_timeout: 10
          },
          instances: [
            {
              url: 'http://localhost:11111'
            }
          ]
        },
        custom_check_2: {
          init_config: {
            default_timeout: 5
          },
          instances: [
            {
              url: 'http://localhost:22222'
            }
          ]
        },
        custom_check_3: {
          init_config: {
            default_timeout: 5
          },
          instances: [
            {
              url: 'http://localhost:33333'
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it { is_expected.to add_datadog_monitor('custom_check_1') }
  it { is_expected.to add_datadog_monitor('custom_check_2') }
  it { is_expected.not_to add_datadog_monitor('custom_check_3') }

  it 'copies the cookbook file from datadog_test to the agent custom check folder' do
    expect(chef_run).to render_file('/etc/dd-agent/checks.d/custom_check_1.py').with_content(
      File.read('spec/fixtures/site-cookbooks/datadog_test/files/custom_check_1.py')
    )
    expect(chef_run).to render_file('/etc/dd-agent/checks.d/custom_check_2.py').with_content(
      File.read('spec/fixtures/site-cookbooks/datadog_test/files/custom_folder/custom_check_2.py')
    )
  end

  it 'renders expected YAML config file' do
    expect(chef_run).to render_file('/etc/dd-agent/conf.d/custom_check_1.yaml').with_content { |content|
      expect(YAML.load(content).to_json).to be_json_eql(YAML.load(expected_yaml1).to_json)
    }
    expect(chef_run).to render_file('/etc/dd-agent/conf.d/custom_check_2.yaml').with_content { |content|
      expect(YAML.load(content).to_json).to be_json_eql(YAML.load(expected_yaml2).to_json)
    }
  end
end
