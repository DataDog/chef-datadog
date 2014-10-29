require 'spec_helper'

shared_examples_for 'common resources' do
  it 'includes the repository recipe' do
    expect(@chef_run).to include_recipe('datadog::repository')
  end

  it 'ensures the dd-agent directory exists' do
    expect(@chef_run).to create_directory '/etc/dd-agent'
  end

  it 'drops an agent config file' do
    expect(@chef_run).to create_template '/etc/dd-agent/datadog.conf'
  end

  it 'enables the datadog-agent service' do
    expect(@chef_run).to enable_service 'datadog-agent'
  end

  it 'starts the datadog-agent service' do
    expect(@chef_run).to start_service 'datadog-agent'
  end
end

shared_examples_for 'datadog-agent' do
  it 'installs the datadog-agent' do
    expect(@chef_run).to install_package 'datadog-agent'
  end

  it 'does not install the datadog-agent-base package' do
    expect(@chef_run).not_to install_package 'datadog-agent-base'
  end
end

shared_examples_for 'datadog-agent-base' do
  it_behaves_like 'common resources'

  it 'installs the datadog-agent-base package' do
    expect(@chef_run).to install_package 'datadog-agent-base'
  end

  it 'does not install the datadog-agent package' do
    expect(@chef_run).not_to install_package 'datadog-agent'
  end
end

shared_examples_for 'no version set' do
  it_behaves_like 'common resources'

  it_behaves_like 'datadog-agent'
end

shared_examples_for 'version set below 4.x' do
  it_behaves_like 'common resources'

  it_behaves_like 'datadog-agent-base'
end


describe 'datadog::dd-agent' do
  context 'no version set' do
    # This recipe needs to have an api_key, otherwise `raise` is called.
    # It also depends on the version of Python present on the platform:
    #   2.6 and up => datadog-agent is installed
    #   below 2.6 => datadog-agent-base is installed
    context 'on debian-family distro' do
      before(:all) do
        @chef_run = ChefSpec::Runner.new(
          platform: 'ubuntu',
          version: '12.04',
        ) do |node|
            node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
          end
        @chef_run.converge 'datadog::dd-agent'
      end

      it_behaves_like 'no version set'
    end

    context 'on debian-family w/non-numeric python version string' do
      before(:all) do
        @chef_run = ChefSpec::Runner.new(
          :platform => 'debian',
          :version => '7.2'
        ) do |node|
            node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.set['languages'] = { 'python' => { 'version' => '2.7.5+' } }
          end
        @chef_run.converge 'datadog::dd-agent'
      end

      it_behaves_like 'no version set'
    end

    context 'on debian-family with older python' do
      before(:all) do
        @chef_run = ChefSpec::Runner.new(
          :platform => 'ubuntu',
          :version => '12.04'
        ) do |node|
            node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.set['languages'] = { 'python' => { 'version' => '2.4' } }
          end
        @chef_run.converge 'datadog::dd-agent'
      end

      it_behaves_like 'no version set'
    end

    context 'on RedHat-family distro above 6.x' do
      before(:all) do
        @chef_run = ChefSpec::Runner.new(
          :platform => 'centos',
          :version => '6.3'
        ) do |node|
            node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
          end.converge('datadog::dd-agent')
      end

      it_behaves_like 'no version set'
    end

    context 'on CentOS 5.8 distro' do
      before(:all) do
        @chef_run = ChefSpec::Runner.new(
          :platform => 'centos',
          :version => '5.8'
        ) do |node|
            node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.set['languages'] = { 'python' => { 'version' => '2.4.3' } }
          end.converge('datadog::dd-agent')
      end

      it_behaves_like 'no version set'
    end
  end

  context 'version 5.x is set' do
    before(:all) do
      @chef_run = ChefSpec::Runner.new(
        :platform => 'ubuntu',
        :version => '14.04'
      ) do |node|
          node.set['datadog'] = {
            'api_key' => 'somethingnotnil',
            'agent_version' => '5.1.0-440'
          }
          node.set['languages'] = { 'python' => { 'version' => '2.4' } }
        end
      @chef_run.converge 'datadog::dd-agent'
    end

    it_behaves_like 'no version set'
  end

  context 'version 4.x is set' do
    before(:all) do
      @chef_run = ChefSpec::Runner.new(
        :platform => 'ubuntu',
        :version => '10.04'
      ) do |node|
          node.set['datadog'] = {
            'api_key' => 'somethingnotnil',
            'agent_version' => '4.4.0-200'
          }
          node.set['languages'] = { 'python' => { 'version' => '2.4' } }
        end
      @chef_run.converge 'datadog::dd-agent'
    end

    it_behaves_like 'version set below 4.x'
  end
end
