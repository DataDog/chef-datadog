require 'spec_helper'

shared_examples_for 'datadog-agent' do
  it 'installs the datadog-agent' do
    expect(@chef_run).to install_package 'datadog-agent'
  end

  it 'does not install the datadog-agent-base package' do
    expect(@chef_run).not_to install_package 'datadog-agent-base'
  end

  it 'enables the datadog-agent service' do
    expect(@chef_run).to set_service_to_start_on_boot 'datadog-agent'
  end

  it 'ensures the dd-agent directory exists' do
    expect(@chef_run).to create_directory '/etc/dd-agent'
  end

  it 'drops an agent config file' do
    expect(@chef_run).to create_file '/etc/dd-agent/datadog.conf'
  end
end

shared_examples_for 'datadog-agent-base' do
  it 'installs the datadog-agent-base package' do
    expect(@chef_run).to install_package 'datadog-agent-base'
  end

  it 'does not install the datadog-agent package' do
    expect(@chef_run).not_to install_package 'datadog-agent'
  end

  it 'enables the datadog-agent service' do
    expect(@chef_run).to set_service_to_start_on_boot 'datadog-agent'
  end

  it 'ensures the dd-agent directory exists' do
    expect(@chef_run).to create_directory '/etc/dd-agent'
  end

  it 'drops an agent config file' do
    expect(@chef_run).to create_file '/etc/dd-agent/datadog.conf'
  end
end



describe 'datadog::dd-agent' do

  # This recipe needs to have an api_key, otherwise `raise` is called.
  # It also depends on the version of Python present on the platform:
  #   2.6 and up => datadog-agent is installed
  #   below 2.6 => datadog-agent-base is installed
  context 'when using a debian-family distro' do

    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(
        :platform => 'ubuntu',
        :version => '12.04'
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge('datadog::dd-agent')
    end

    it_behaves_like 'datadog-agent'
  end

  context 'when using a debian-family distro and installing base' do

    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(
        :platform => 'ubuntu',
        :version => '12.04'
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.4' } }
        end.converge('datadog::dd-agent')
    end

    it_behaves_like 'datadog-agent-base'
  end

  context 'when using a redhat-family distro above 6.x' do

    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(
        :platform => 'centos',
        :version => '6.3'
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge('datadog::dd-agent')
    end

    it_behaves_like 'datadog-agent'
  end

  context 'when using CentOS 5.8 and installing base' do

    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(
        :platform => 'centos',
        :version => '5.8'
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          # fauxhai currently does not have languages other than Ruby, so we
          # add it here. See https://github.com/customink/fauxhai/issues/39
          node.set['languages'] = { 'python' => { 'version' => '2.4.3' } }
        end.converge('datadog::dd-agent')
    end

    it_behaves_like 'datadog-agent-base'
  end

end
