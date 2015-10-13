shared_examples_for 'common resources' do
  it 'includes the repository recipe' do
    expect(chef_run).to include_recipe('datadog::repository')
  end

  it 'ensures the dd-agent directory exists' do
    expect(chef_run).to create_directory '/etc/dd-agent'
  end

  it 'drops an agent config file' do
    expect(chef_run).to create_template '/etc/dd-agent/datadog.conf'
  end

  it 'enables the datadog-agent service' do
    expect(chef_run).to enable_service 'datadog-agent'
  end

  it 'starts the datadog-agent service' do
    expect(chef_run).to start_service 'datadog-agent'
  end
end

shared_examples_for 'datadog-agent' do
  it_behaves_like 'common resources'

  it 'installs the datadog-agent' do
    expect(chef_run).to install_package 'datadog-agent'
  end

  it 'does not install the datadog-agent-base package' do
    expect(chef_run).not_to install_package 'datadog-agent-base'
  end
end
