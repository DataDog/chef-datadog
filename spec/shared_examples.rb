shared_examples_for 'datadog-agent service' do
  it 'enables the datadog-agent service' do
    expect(chef_run).to enable_service 'datadog-agent'
  end

  it 'starts the datadog-agent service' do
    expect(chef_run).to start_service 'datadog-agent'
  end
end

shared_examples_for 'datadog conf' do
  it 'does not complain about a missing api key' do
    expect(chef_run).not_to run_ruby_block('datadog-api-key-unset')
  end
end

# Common linux resources for Agent v5, see 'common linux resources' for Agent v6
shared_examples_for 'common linux resources v5' do
  it_behaves_like 'datadog-agent service'
  it_behaves_like 'datadog conf'

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

# Common linux resources for Agent v6, see 'common linux resource v5' for Agent v5
shared_examples_for 'common linux resources' do
  it_behaves_like 'datadog-agent service'
  it_behaves_like 'datadog conf'

  it 'includes the repository recipe' do
    expect(chef_run).to include_recipe('datadog::repository')
  end

  it 'drops an agent config file' do
    expect(chef_run).to create_template '/etc/datadog-agent/datadog.yaml'
  end
end

shared_examples_for 'datadog-agent v5' do
  it_behaves_like 'common linux resources v5'
end

shared_examples_for 'datadog-agent' do
  it_behaves_like 'common linux resources'
end

shared_examples_for 'debianoids datadog-agent v5' do
  it_behaves_like 'datadog-agent v5'

  it 'installs the datadog-agent' do
    expect(chef_run).to install_apt_package 'datadog-agent'
  end
end

shared_examples_for 'debianoids datadog-agent' do
  it_behaves_like 'datadog-agent'

  it 'installs the datadog-agent' do
    expect(chef_run).to install_apt_package 'datadog-agent'
  end
end

shared_examples_for 'rhellions datadog-agent v5' do
  it_behaves_like 'datadog-agent v5'

  it 'installs the datadog-agent' do
    expect(chef_run).to install_yum_package 'datadog-agent'
  end
end

shared_examples_for 'rhellions datadog-agent' do
  it_behaves_like 'datadog-agent'

  it 'installs the datadog-agent' do
    expect(chef_run).to install_yum_package 'datadog-agent'
  end
end

shared_examples_for 'common windows resources' do
  it_behaves_like 'datadog-agent service'
  it_behaves_like 'datadog conf'

  it 'drops an agent config file' do
    expect(chef_run).to create_template 'C:\ProgramData/Datadog/datadog.yaml'
  end

  it 'does not render a go-metro log config' do
    expect(chef_run).to_not render_file('C:\ProgramData/Datadog/datadog.yaml').with_content(/^go-metro_log_file.*$/)
  end
end

shared_examples_for 'common windows resources v5' do
  it_behaves_like 'datadog-agent service'
  it_behaves_like 'datadog conf'

  it 'ensures the Datadog config directory exists' do
    expect(chef_run).to create_directory 'C:\ProgramData/Datadog'
  end

  it 'drops an agent config file' do
    expect(chef_run).to create_template 'C:\ProgramData/Datadog/datadog.conf'
  end

  it 'does not render a go-metro log config' do
    expect(chef_run).to_not render_file('C:\ProgramData/Datadog/datadog.conf').with_content(/^go-metro_log_file.*$/)
  end
end

shared_examples_for 'windows Datadog Agent v5' do |installer_extension|
  it_behaves_like 'common windows resources v5'

  agent_installer = "C:/chef/cache/ddagent-cli.#{installer_extension}"

  it 'downloads the remote file only if it\'s changed' do
    expect(chef_run).to create_remote_file(agent_installer)
  end

  it 'doesn\'t remove existing version of the Datadog Agent by default' do
    expect(chef_run.package('Datadog Agent removal')).to do_nothing
  end

  it 'notifies the removal of the Datadog Agent when a remote file is downloaded' do
    expect(chef_run.powershell_script('datadog_6.14.x_fix')).to notify('package[Datadog Agent removal]').to(:remove)
  end

  it 'notifies the execution of the powershell fix when a remote file is downloaded' do
    expect(chef_run.remote_file(agent_installer)).to notify('powershell_script[datadog_6.14.x_fix]').to(:run)
  end

  it 'installs Datadog Agent' do
    installer_type = installer_extension == :msi ? :msi : :custom
    expect(chef_run).to install_windows_package('Datadog Agent').with(installer_type: installer_type)
  end
end

shared_examples_for 'windows Datadog Agent' do |installer_extension|
  it_behaves_like 'common windows resources'

  agent_installer = "C:/chef/cache/ddagent-cli.#{installer_extension}"

  it 'downloads the remote file only if it\'s changed' do
    expect(chef_run).to create_remote_file(agent_installer)
  end

  it 'doesn\'t remove existing version of the Datadog Agent by default' do
    expect(chef_run.package('Datadog Agent removal')).to do_nothing
  end

  it 'notifies the removal of the Datadog Agent when a remote file is downloaded' do
    expect(chef_run.powershell_script('datadog_6.14.x_fix')).to notify('package[Datadog Agent removal]').to(:remove)
  end

  it 'notifies the execution of the powershell fix when a remote file is downloaded' do
    expect(chef_run.remote_file(agent_installer)).to notify('powershell_script[datadog_6.14.x_fix]').to(:run)
  end

  it 'installs Datadog Agent' do
    installer_type = installer_extension == :msi ? :msi : :custom
    expect(chef_run).to install_windows_package('Datadog Agent').with(installer_type: installer_type)
  end
end
