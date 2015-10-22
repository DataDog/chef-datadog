shared_examples_for 'datadog-agent service' do
  it 'enables the datadog-agent service' do
    expect(chef_run).to enable_service 'datadog-agent'
  end

  it 'starts the datadog-agent service' do
    expect(chef_run).to start_service 'datadog-agent'
  end
end

shared_examples_for 'common linux resources' do
  it_behaves_like 'datadog-agent service'

  it 'includes the repository recipe' do
    expect(chef_run).to include_recipe('datadog::repository')
  end

  it 'ensures the dd-agent directory exists' do
    expect(chef_run).to create_directory '/etc/dd-agent'
  end

  it 'drops an agent config file' do
    expect(chef_run).to create_template '/etc/dd-agent/datadog.conf'
  end
end

shared_examples_for 'datadog-agent' do
  it_behaves_like 'common linux resources'

  it 'installs the datadog-agent' do
    expect(chef_run).to install_package 'datadog-agent'
  end

  it 'does not install the datadog-agent-base package' do
    expect(chef_run).not_to install_package 'datadog-agent-base'
  end
end

shared_examples_for 'common windows resources' do
  it_behaves_like 'datadog-agent service'

  it 'ensures the Datadog config directory exists' do
    expect(chef_run).to create_directory 'C:\ProgramData/Datadog'
  end

  it 'drops an agent config file' do
    expect(chef_run).to create_template 'C:\ProgramData/Datadog/datadog.conf'
  end
end

shared_examples_for 'windows Datadog Agent' do
  it_behaves_like 'common windows resources'

  it 'downloads the remote file only if it\'s changed' do
    expect(chef_run).to create_remote_file('MSI installer')
  end

  it 'notifies the removal of the Datadog Agent' do
    expect(chef_run.remote_file('MSI installer')).to notify('windows_package[Datadog Agent]').to(:remove)
  end

  it 'installs Datadog Agent' do
    expect(chef_run).to install_windows_package('Datadog Agent')
  end
end
