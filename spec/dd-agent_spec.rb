require 'spec_helper'

module EnvVar
  def set_env_var(name, value)
    allow(ENV).to receive(:[])
    allow(ENV).to receive(:[]).with(name).and_return(value)
  end
end

shared_examples_for 'datadog-agent-base' do
  it_behaves_like 'common linux resources'

  it 'installs the datadog-agent-base package' do
    expect(chef_run).to install_package 'datadog-agent-base'
  end

  it 'does not install the datadog-agent package' do
    expect(chef_run).not_to install_package 'datadog-agent'
  end
end

shared_examples_for 'debianoids' do
  it 'sets up an apt repo' do
    expect(chef_run).to add_apt_repository('datadog')
  end

  it 'installs apt-transport-https' do
    expect(chef_run).to install_package('apt-transport-https')
  end
end

shared_examples_for 'rhellions' do
  it 'sets up a yum repo' do
    expect(chef_run).to add_yum_repository('datadog')
  end
end

shared_examples_for 'no version set' do
  it_behaves_like 'common linux resources'

  it_behaves_like 'datadog-agent'
end

shared_examples_for 'version set below 4.x' do
  it_behaves_like 'common linux resources'

  it_behaves_like 'datadog-agent-base'
end

describe 'datadog::dd-agent' do
  include EnvVar

  context 'no version set' do
    # This recipe needs to have an api_key, otherwise `raise` is called.
    # It also depends on the version of Python present on the platform:
    #   2.6 and up => datadog-agent is installed
    #   below 2.6 => datadog-agent-base is installed
    context 'on debian-family distro' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'debianoids'
      it_behaves_like 'no version set'
    end

    context 'on debian-family w/non-numeric python version string' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'debian',
          :version => '7.2'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.7.5+' } }
        end.converge described_recipe
      end

      it_behaves_like 'debianoids'
      it_behaves_like 'no version set'
    end

    context 'on debian-family with older python' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'ubuntu',
          :version => '12.04'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.4' } }
        end.converge described_recipe
      end

      it_behaves_like 'debianoids'
      it_behaves_like 'no version set'
    end

    context 'on RedHat-family distro above 6.x' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'centos',
          :version => '6.3'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'rhellions'
      it_behaves_like 'no version set'
    end

    context 'on CentOS 5.8 distro' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'centos',
          :version => '5.8'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.4.3' } }
        end.converge described_recipe
      end

      it_behaves_like 'rhellions'
      it_behaves_like 'no version set'
    end

    context 'on Fedora distro' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'fedora',
          :version => '21'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.7.9' } }
        end.converge described_recipe
      end

      it_behaves_like 'rhellions'
      it_behaves_like 'no version set'
    end

    context 'on Windows' do
      cached(:chef_run)  do
        set_env_var('ProgramData', 'C:\ProgramData')
        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
        end.converge described_recipe
      end

      it_behaves_like 'windows Datadog Agent'
    end
  end

  context 'version 5.x is set' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        :platform => 'ubuntu',
        :version => '14.04'
      ) do |node|
        node.set['datadog'] = {
          'api_key' => 'somethingnotnil',
          'agent_version' => '5.1.0-440'
        }
        node.set['languages'] = { 'python' => { 'version' => '2.4' } }
      end.converge described_recipe
    end

    it_behaves_like 'debianoids'
    it_behaves_like 'no version set'
  end

  context 'version 4.x is set' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        :platform => 'ubuntu',
        :version => '10.04'
      ) do |node|
        node.set['datadog'] = {
          'api_key' => 'somethingnotnil',
          'agent_version' => '4.4.0-200'
        }
        node.set['languages'] = { 'python' => { 'version' => '2.4' } }
      end.converge described_recipe
    end

    it_behaves_like 'debianoids'
    it_behaves_like 'version set below 4.x'
  end

  context 'package action' do
    context 'default :install' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'debianoids'
      it_behaves_like 'no version set'
    end

    context 'override with :upgrade' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        ) do |node|
          node.set['datadog'] = { 'api_key' => 'somethingnotnil', 'agent_package_action' => :upgrade }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it 'upgrades the datadog-agent package' do
        expect(chef_run).to upgrade_package('datadog-agent')
      end

      it_behaves_like 'debianoids'
    end
  end
end
