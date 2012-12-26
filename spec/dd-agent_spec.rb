require 'spec_helper'

describe 'datadog::dd-agent' do

  # This recipe needs to have an api_key, otherwise `raise` is called.
  # It also depends on specific platofrm versions for software install
  context 'when using a debian-family distro' do
    before do
      Fauxhai.mock(:platform => 'ubuntu', :version => '12.04') do |node|
        node['datadog'] = { :api_key => "somethingnotnil" }
      end
    end

    let (:chef_run) { ChefSpec::ChefRunner.new.converge 'datadog::dd-agent' }

    it 'sets up an apt repository' do
      pending "step into apt"
    end

    it 'installs the datadog-agent' do
      chef_run.should install_package 'datadog-agent'
    end

    it 'enables the datadog-agent service' do
      chef_run.should set_service_to_start_on_boot 'datadog-agent'
    end

    it 'ensures the dd-agent directory exists' do
      chef_run.should create_directory '/etc/dd-agent'
    end

    it 'drops an agent config file' do
      chef_run.should create_file '/etc/dd-agent/datadog.conf'
    end
  end

  context 'when using a redhat-family distro above 6.x' do
    before do
      Fauxhai.mock(platform: 'centos', version: '6.3') do |node|
        node['datadog'] = { :api_key => "somethingnotnil" }
      end
    end

    let (:chef_run) { ChefSpec::ChefRunner.new.converge 'datadog::dd-agent' }

    it 'sets up the EPEL repository' do
      pending "step intp yum::epel?"
    end

    it 'sets up a yum repository' do
      pending "step into yum"
    end

    it 'installs the datadog-agent package' do
      chef_run.should install_package 'datadog-agent'
    end

    it 'does not install the datadog-agent-base package' do
      chef_run.should_not install_package 'datadog-agent-base'
    end

    it 'enables the datadog-agent service' do
      chef_run.should set_service_to_start_on_boot 'datadog-agent'
    end

    it 'creates a configuration file' do
      chef_run.should create_file '/etc/dd-agent/datadog.conf'
      # chef_run.should notify 'service[datadog-agent]', :restart
    end
  end

end
