require 'spec_helper'

shared_examples_for 'datadog-agent' do
  it 'installs the datadog-agent' do
    expect(@chef_run).to install_package 'datadog-agent'
  end

  it 'does not install the datadog-agent-base package' do
    expect(@chef_run).not_to install_package 'datadog-agent-base'
  end

  it 'enables the datadog-agent service' do
    expect(@chef_run).to enable_service 'datadog-agent'
  end

  it 'ensures the dd-agent directory exists' do
    expect(@chef_run).to create_directory '/etc/dd-agent'
  end

  it 'drops an agent config file' do
    expect(@chef_run).to create_template '/etc/dd-agent/datadog.conf'
  end
end

describe 'datadog::dd-agent' do
  # This recipe needs to have an api_key, otherwise `raise` is called.

  context 'when using a debian-family distro' do
    before(:all) do
      @chef_run = ChefSpec::Runner.new(
        platform: 'ubuntu',
        version: '12.04',
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end
      # prevent apt-cache from actually running
      stub_command('apt-cache search datadog-agent | grep datadog-agent').and_return(true)
      @chef_run.converge 'datadog::dd-agent'
    end

    it_behaves_like 'datadog-agent'
  end

  context 'when using a debian-family w/ a non-numeric version string' do
    before(:all) do
      @chef_run = ChefSpec::Runner.new(
        :platform => 'debian',
        :version => '7.2'
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.7.5+' } }
        end
      # prevent apt-cache from actually running
      stub_command('apt-cache search datadog-agent | grep datadog-agent').and_return(true)
      @chef_run.converge 'datadog::dd-agent'
    end

    it_behaves_like 'datadog-agent'
  end

  context 'when using a debian-family distro' do
    before(:all) do
      @chef_run = ChefSpec::Runner.new(
        :platform => 'ubuntu',
        :version => '12.04'
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.4' } }
        end
      # prevent apt-cache from actually running
      stub_command('apt-cache search datadog-agent | grep datadog-agent').and_return(true)
      @chef_run.converge 'datadog::dd-agent'
    end

    it_behaves_like 'datadog-agent'
  end

  context 'when using a redhat-family distro above 6.x' do
    before(:all) do
      @chef_run = ChefSpec::Runner.new(
        :platform => 'centos',
        :version => '6.3'
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge('datadog::dd-agent')
    end

    it_behaves_like 'datadog-agent'
  end

  context 'when using CentOS 5.8' do
    before(:all) do
      @chef_run = ChefSpec::Runner.new(
        :platform => 'centos',
        :version => '5.8'
      ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.4.3' } }
        end.converge('datadog::dd-agent')
    end

    it_behaves_like 'datadog-agent'
  end

end
