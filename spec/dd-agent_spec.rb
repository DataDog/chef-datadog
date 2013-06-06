require 'spec_helper'

describe 'datadog::dd-agent' do

  # This recipe needs to have an api_key, otherwise `raise` is called.
  # It also depends on specific platofrm versions for software install
  context 'when using a debian-family distro' do

    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(
        :platform => 'ubuntu',
        :version => '12.04'
      ) do |node|
          node.set['datadog'] = {
            'api_key' => "somethingnotnil"
          }
        end.converge('datadog::dd-agent')
    end

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

  context 'when using a debian-family distro and installing base' do

    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(
        :platform => 'ubuntu',
        :version => '12.04'
      ) do |node|
          node.set['datadog'] = {
            'api_key' => "somethingnotnil",
            'install_base' => true
          }
        end.converge('datadog::dd-agent')
    end

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

  context 'when using a redhat-family distro above 6.x' do

    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(
        :platform => 'centos',
        :version => '6.3'
      ) do |node|
          node.set['datadog'] = {
            'api_key' => "somethingnotnil"
          }
        end.converge('datadog::dd-agent')
    end

    it 'installs the datadog-agent package' do
      expect(@chef_run).to install_package 'datadog-agent'
    end

    it 'does not install the datadog-agent-base package' do
      expect(@chef_run).not_to install_package 'datadog-agent-base'
    end

    it 'enables the datadog-agent service' do
      expect(@chef_run).to set_service_to_start_on_boot 'datadog-agent'
    end

    it 'creates a configuration file' do
      expect(@chef_run).to create_file '/etc/dd-agent/datadog.conf'
    end

  end

  context 'when using a redhat-family distro above 6.x and installing base' do

    before(:all) do
      @chef_run = ChefSpec::ChefRunner.new(
        :platform => 'centos',
        :version => '6.3'
      ) do |node|
          node.set['datadog'] = {
            'api_key' => "somethingnotnil",
            'install_base' => true
          }
        end.converge('datadog::dd-agent')
    end

    it 'installs the datadog-agent-base package' do
      expect(@chef_run).to install_package 'datadog-agent-base'
    end

    it 'does not install the datadog-agent package' do
      expect(@chef_run).not_to install_package 'datadog-agent'
    end

    it 'enables the datadog-agent service' do
      expect(@chef_run).to set_service_to_start_on_boot 'datadog-agent'
    end

    it 'creates a configuration file' do
      expect(@chef_run).to create_file '/etc/dd-agent/datadog.conf'
    end

  end

end
