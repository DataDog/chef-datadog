require 'spec_helper'
require 'digest'

module EnvVar
  def set_env_var(name, value)
    allow(ENV).to receive(:[])
    allow(ENV).to receive(:[]).with(name).and_return(value)
  end
end

shared_examples_for 'repo recipe' do
  it 'includes the repository recipe' do
    expect(chef_run).to include_recipe('datadog::repository')
  end
end

shared_examples_for 'debianoids no version set' do
  it_behaves_like 'common linux resources'

  it_behaves_like 'debianoids datadog-agent'
end

shared_examples_for 'rhellions no version set' do
  it_behaves_like 'common linux resources'

  it_behaves_like 'rhellions datadog-agent'
end

shared_examples_for 'version set below 4.x' do
  it_behaves_like 'common linux resources v5'
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
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'repo recipe'
      it_behaves_like 'debianoids no version set'
    end

    context 'on debian-family w/non-numeric python version string' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'debian',
          :version => '7.11'
        ) do |node|
          node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.normal['languages'] = { 'python' => { 'version' => '2.7.5+' } }
        end.converge described_recipe
      end

      it_behaves_like 'repo recipe'
      it_behaves_like 'debianoids no version set'
    end

    context 'on debian-family with older python' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'ubuntu',
          :version => '14.04'
        ) do |node|
          node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.normal['languages'] = { 'python' => { 'version' => '2.4' } }
        end.converge described_recipe
      end

      it_behaves_like 'repo recipe'
      it_behaves_like 'debianoids no version set'
    end

    context 'on RedHat-family distro above 6.x' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'centos',
          :version => '6.9'
        ) do |node|
          node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'repo recipe'
      it_behaves_like 'rhellions no version set'
    end

    context 'on CentOS 5.11 distro' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'centos',
          :version => '5.11'
        ) do |node|
          node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.normal['languages'] = { 'python' => { 'version' => '2.4.3' } }
        end.converge described_recipe
      end

      it_behaves_like 'repo recipe'
      it_behaves_like 'rhellions no version set'
    end

    context 'on Fedora distro' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'fedora',
          :version => '26'
        ) do |node|
          node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
          node.normal['languages'] = { 'python' => { 'version' => '2.7.9' } }
        end.converge described_recipe
      end

      it_behaves_like 'repo recipe'
      it_behaves_like 'rhellions no version set'
    end

    context 'on Windows' do
      cached(:chef_run) do
        set_env_var('ProgramData', 'C:\ProgramData')
        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2',
          :file_cache_path => 'C:/chef/cache'
        ) do |node|
          node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
        end.converge described_recipe
      end

      temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')
      mock_digest = Digest::SHA256.new

      before do
        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).with(temp_file).and_return('foo')
        allow(Digest::SHA256).to receive(:file).and_call_original
        allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
        allow(Chef::Datadog::WindowsInstallHelpers)
          .to receive(:must_reinstall?)
          .and_return(true)
      end

      it_behaves_like 'windows Datadog Agent', :msi
    end

    context 'on Windows with EXE installer' do
      cached(:chef_run) do
        set_env_var('ProgramData', 'C:\ProgramData')
        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2',
          :file_cache_path => 'C:/chef/cache'
        ) do |node|
          node.normal['datadog'] = {
            'api_key' => 'somethingnotnil',
            'windows_agent_use_exe' => true
          }
        end.converge described_recipe
      end

      temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.exe')
      mock_digest = Digest::SHA256.new

      before do
        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).with(temp_file).and_return('foo')
        allow(Digest::SHA256).to receive(:file).and_call_original
        allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
        allow(Chef::Datadog::WindowsInstallHelpers)
          .to receive(:must_reinstall?)
          .and_return(true)
      end

      it_behaves_like 'windows Datadog Agent', :exe
    end
  end

  context 'version 5.x is set' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        :platform => 'ubuntu',
        :version => '14.04'
      ) do |node|
        node.normal['datadog'] = {
          'agent_major_version' => 5,
          'api_key' => 'somethingnotnil',
          'agent_version' => '1:5.1.0-440'
        }
        node.normal['languages'] = { 'python' => { 'version' => '2.4' } }
      end.converge described_recipe
    end

    it_behaves_like 'repo recipe'
    it_behaves_like 'common linux resources v5'
    it 'installs the datadog-agent' do
      expect(chef_run).to install_apt_package 'datadog-agent'
    end
  end

  context 'allows a string for agent version' do
    context 'on linux' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'ubuntu',
          :version => '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'agent_version' => '1:5.9.0-1'
          }
        end.converge described_recipe
      end

      it 'installs agent 1:5.9.0-1' do
        expect(chef_run).to install_apt_package('datadog-agent').with(version: '1:5.9.0-1')
      end
    end

    context 'on windows' do
      cached(:chef_run) do
        set_env_var('ProgramData', 'C:\ProgramData')

        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2',
          :file_cache_path => 'C:/chef/cache'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'agent_version' => '5.10.1'
          }
        end.converge described_recipe
      end

      temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')
      mock_digest = Digest::SHA256.new

      before do
        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).with(temp_file).and_return('foo')
        allow(Digest::SHA256).to receive(:file).and_call_original
        allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
        allow(Chef::Datadog::WindowsInstallHelpers)
          .to receive(:must_reinstall?)
          .and_return(true)
      end

      it_behaves_like 'windows Datadog Agent v5', :msi
      # remote_file source gets converted to an array, so we need to do
      # some tricky things to be able to regex against it
      # Relevant: http://stackoverflow.com/a/12325983
      it 'installs agent 5.10.1' do
        expect(chef_run.remote_file(temp_file).source.to_s)
          .to match(/ddagent-cli-5.10.1.msi/)
      end
    end

    context 'agent 5 latest on windows' do
      cached(:chef_run) do
        set_env_var('ProgramData', 'C:\ProgramData')
        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2',
          :file_cache_path => 'C:/chef/cache'
        ) do |node|
          node.normal['datadog'] = {
            'api_key' => 'somethingnotnil',
            'agent_major_version' => 5,
          }
        end.converge described_recipe
      end

      temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')

      it 'installs Datadog Agent' do
        expect(chef_run).to install_windows_package('Datadog Agent').with(installer_type: :msi)
      end

      # remote_file source gets converted to an array, so we need to do
      # some tricky things to be able to regex against it
      # Relevant: http://stackoverflow.com/a/12325983
      it 'installs agent latest' do
        expect(chef_run.remote_file(temp_file).source.to_s)
          .to match(/ddagent-cli-latest.msi/)
      end
    end
  end

  # Allow a hash for Agent version 6
  # ----------------------

  context 'allows a hash for agent version' do
    context 'when ubuntu' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'ubuntu',
          :version => '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 6,
            'api_key' => 'somethingnotnil',
            'agent_version' => {
              'debian' => '1:6.9.0-1',
              'rhel' => '6.9.0-1',
            }
          }
        end.converge described_recipe
      end

      it_behaves_like 'debianoids datadog-agent'
    end

    context 'when windows' do
      cached(:chef_run) do
        set_env_var('ProgramData', 'C:\ProgramData')

        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2',
          :file_cache_path => 'C:/chef/cache'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 6,
            'api_key' => 'somethingnotnil',
            'agent_version' => {
              'debian' => '1:6.9.0-1',
              'rhel' => '6.9.0-1',
              'windows' => '6.9.0',
            }
          }
        end.converge described_recipe
      end

      temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')
      mock_digest = Digest::SHA256.new

      before do
        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).with(temp_file).and_return('foo')
        allow(Digest::SHA256).to receive(:file).and_call_original
        allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
        allow(Chef::Datadog::WindowsInstallHelpers)
          .to receive(:must_reinstall?)
          .and_return(true)
      end

      it_behaves_like 'windows Datadog Agent', :msi
      # remote_file source gets converted to an array, so we need to do
      # some tricky things to be able to regex against it
      # Relevant: http://stackoverflow.com/a/12325983
      # But we should probably assert the full default attribute somewhere...
      it 'installs agent 6.9.0' do
        expect(chef_run.remote_file(temp_file).source.to_s)
          .to match(/ddagent-cli-6.9.0.msi/)
      end
    end

    context 'when windows and custom url+prefix' do
      cached(:chef_run) do
        set_env_var('ProgramData', 'C:\ProgramData')
        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2',
          :file_cache_path => 'C:/chef/cache'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 6,
            'api_key' => 'somethingnotnil',
            'windows_agent_url' => 'http://dd-agent-mstesting.s3.amazonaws.com/builds/tagged/',
            'windows_agent_installer_prefix' => 'datadog-agent',
            'agent_version' => {
              'debian' => '1:6.9.0-1',
              'rhel' => '6.9.0-1',
              'windows' => '6.9.0-1-x86_64'
            }
          }
        end.converge described_recipe
      end

      temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')
      mock_digest = Digest::SHA256.new

      before do
        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).with(temp_file).and_return('foo')
        allow(Digest::SHA256).to receive(:file).and_call_original
        allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
        allow(Chef::Datadog::WindowsInstallHelpers)
          .to receive(:must_reinstall?)
          .and_return(true)
      end

      it_behaves_like 'windows Datadog Agent', :msi
      # remote_file source gets converted to an array, so we need to do
      # some tricky things to be able to regex against it
      # Relevant: http://stackoverflow.com/a/12325983
      # But we should probably assert the full default attribute somewhere...
      it 'installs agent 6.9.0' do
        expect(chef_run.remote_file(temp_file).source.to_s)
          .to match(/datadog-agent-6.9.0-1-x86_64.msi/)
      end
    end

    context 'when fedora' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'fedora',
          :version => '26'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 6,
            'api_key' => 'somethingnotnil',
            'agent_version' => {
              'debian' => '1:6.9.0-1',
              'rhel' => '6.9.0-1',
            }
          }
        end.converge described_recipe
      end

      it_behaves_like 'rhellions datadog-agent'
    end

    context 'when rhel' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'redhat',
          :version => '6.9'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 6,
            'api_key' => 'somethingnotnil',
            'agent_version' => {
              'debian' => '1:6.9.0-1',
              'rhel' => '6.9.0-1',
            },
          }
        end.converge described_recipe
      end

      it_behaves_like 'rhellions datadog-agent'
    end
  end

  # Allow a hash for Agent version 5
  # ----------------------

  context 'allows a hash for agent version v5' do
    context 'when ubuntu' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'ubuntu',
          :version => '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'agent_version' => {
              'debian' => '1:5.32.2-1',
              'rhel' => '5.32.2-1',
              'windows' => '5.4.0'
            },
          }
        end.converge described_recipe
      end

      it_behaves_like 'debianoids datadog-agent v5'
    end

    context 'when windows' do
      cached(:chef_run) do
        set_env_var('ProgramData', 'C:\ProgramData')
        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2',
          :file_cache_path => 'C:/chef/cache'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'agent_version' => {
              'debian' => '1:5.32.2-1',
              'rhel' => '5.32.2-1',
              'windows' => '5.4.0'
            },
          }
        end.converge described_recipe
      end

      temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')
      mock_digest = Digest::SHA256.new

      before do
        allow(File).to receive(:open).and_call_original
        allow(File).to receive(:open).with(temp_file).and_return('foo')
        allow(Digest::SHA256).to receive(:file).and_call_original
        allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
        allow(Chef::Datadog::WindowsInstallHelpers)
          .to receive(:must_reinstall?)
          .and_return(true)
      end

      it_behaves_like 'windows Datadog Agent v5', :msi
      # remote_file source gets converted to an array, so we need to do
      # some tricky things to be able to regex against it
      # Relevant: http://stackoverflow.com/a/12325983
      # But we should probably assert the full default attribute somewhere...
      it 'installs agent 5.4.0' do
        expect(chef_run.remote_file(temp_file).source.to_s)
          .to match(/ddagent-cli-5.4.0.msi/)
      end
    end

    context 'when fedora' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'fedora',
          :version => '26'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'agent_version' => {
              'debian' => '1:5.32.2-1',
              'rhel' => '5.32.2-1',
              'windows' => '5.4.0'
            },
          }
        end.converge described_recipe
      end

      it_behaves_like 'rhellions datadog-agent v5'
    end

    context 'when rhel' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          :platform => 'redhat',
          :version => '6.9'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'agent_version' => {
              'debian' => '1:5.32.2-1',
              'rhel' => '5.32.2-1',
              'windows' => '5.4.0'
            },
          }
        end.converge described_recipe
      end

      it_behaves_like 'rhellions datadog-agent v5'
    end
  end

  context 'package action' do
    context 'default :install' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_version' => '1:6.8.0-1',
            'api_key' => 'somethingnotnil'
          }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'repo recipe'
      it_behaves_like 'debianoids no version set'
    end

    context 'override with :upgrade' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'api_key' => 'somethingnotnil',
            'agent_package_action' => :upgrade
          }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it 'upgrades the datadog-agent package' do
        expect(chef_run).to upgrade_apt_package('datadog-agent')
      end

      it_behaves_like 'repo recipe'
    end
  end

  # ----------------------
  # Agent v5 configuration tests

  context 'datadog.conf configuration' do
    context 'allows a string for tags' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'tags' => 'datacenter:us-foo,database:bar'
          }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources v5'

      it 'sets tags from the tags attribute' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^tags: datacenter:us-foo,database:bar$/)
      end
    end

    context 'allows key/value for tags' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'tags' => { 'datacenter' => 'us-foo', 'database' => 'bar' }
          }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources v5'

      it 'sets tags from the tags attribute' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^tags: datacenter:us-foo,database:bar$/)
      end
    end

    context 'does not use empty tags' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'somethingnotnil',
            'tags' => { 'datacenter' => 'us-foo', 'database' => '' }
          }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources v5'

      it 'sets tags from the tags attribute' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^tags: datacenter:us-foo$/)
      end
    end

    context 'does accept extra endpoints' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'something1',
            'url' => 'https://app.example.com',
            'extra_endpoints' => {
              'example' => {
                'enabled' => true,
                'api_key' => 'something2',
                'url' => 'https://app.datadoghq.com'
              }
            }
          }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources v5'

      it 'uses the multiples apikeys and urls' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^api_key: something1,something2$/)
          .with_content(%r{^dd_url: https://app.example.com,https://app.datadoghq.com$})
      end
    end

    context 'does accept extra api_key' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'something1',
            'url' => 'https://app.example.com',
            'extra_endpoints' => {
              'example' => {
                'enabled' => true,
                'api_key' => 'something2'
              }
            }
          }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources v5'

      it 'uses the multiples apikeys and urls' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^api_key: something1,something2$/)
          .with_content(%r{^dd_url: https://app.example.com,https://app.example.com$})
      end
    end

    context 'with no api_key set' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it 'raises an error' do
        expect(chef_run).to run_ruby_block('datadog-api-key-unset')
      end
    end

    context 'with api_key set as node attribute and on node run_state' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['datadog'] = {
            'agent_major_version' => 5,
            'api_key' => 'as_node_attribute',
            'url' => 'https://app.example.com'
          }
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
          node.run_state['datadog'] = { 'api_key' => 'on_run_state' }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources v5'

      it 'uses the api_key from the run_state' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^api_key: on_run_state$/)

        expect(chef_run).not_to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/api_key: as_node_attribute/)
      end
    end

    context 'with api_key set on node run_state only' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '14.04'
        ) do |node|
          node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
          node.normal['datadog'] = { 'agent_major_version' => 5 }
          node.run_state['datadog'] = {
            'api_key' => 'on_run_state'
          }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources v5'

      it 'uses the api_key from the run_state' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^api_key: on_run_state$/)
      end
    end
  end

  context 'does accept extra config options' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.normal['datadog'] = {
          'agent_major_version' => 5,
          'api_key' => 'something1',
          'url' => 'https://app.example.com',
          'extra_config' => {
            'example_key' => 'example_value',
            'false_key' => false,
            'no_example_key' => nil
          }
        }
        node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
      end.converge described_recipe
    end

    it_behaves_like 'common linux resources v5'

    it 'uses the multiples apikeys and urls' do
      expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
        .with_content(/^example_key: example_value$/)
        .with_content(/^false_key: false$/)
        .with_content(/^# Other config options$/)

      expect(chef_run).to_not render_file('/etc/dd-agent/datadog.conf')
        .with_content(/^no_example_key:/)
    end
  end

  # End of Agent v5 configuration tests
  # ----------------------

  context 'package downgrade' do
    context 'left to default' do
      context 'on debianoids' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: 'ubuntu',
            version: '14.04'
          ) do |node|
            node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
          end.converge described_recipe
        end

        it_behaves_like 'common linux resources'
        it_behaves_like 'debianoids no version set'

        it 'does not allow downgrade' do
          expect(chef_run).to install_apt_package('datadog-agent')
            .with(options: nil)
        end
      end

      context 'on rhellions' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: 'centos',
            version: '6.9'
          ) do |node|
            node.normal['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
          end.converge described_recipe
        end

        it_behaves_like 'common linux resources'
        it_behaves_like 'rhellions no version set'

        it 'does not allow downgrade' do
          expect(chef_run).to install_yum_package('datadog-agent')
            .with(allow_downgrade: false)
        end
      end
    end

    context 'set to true' do
      context 'on debianoids' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: 'ubuntu',
            version: '14.04'
          ) do |node|
            node.normal['datadog'] = {
              'api_key' => 'somethingnotnil',
              'agent_allow_downgrade' => true
            }
            node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
          end.converge described_recipe
        end

        it_behaves_like 'common linux resources'
        it_behaves_like 'debianoids no version set'

        it 'allows downgrade' do
          expect(chef_run).to install_apt_package('datadog-agent')
            .with(options: ['--force-yes'])
        end
      end

      context 'on rhellions' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: 'centos',
            version: '6.9'
          ) do |node|
            node.normal['datadog'] = {
              'api_key' => 'somethingnotnil',
              'agent_allow_downgrade' => true
            }
            node.normal['languages'] = { 'python' => { 'version' => '2.6.2' } }
          end.converge described_recipe
        end

        it_behaves_like 'common linux resources'
        it_behaves_like 'rhellions no version set'

        it 'allows downgrade' do
          expect(chef_run).to install_yum_package('datadog-agent')
            .with(allow_downgrade: true)
        end
      end
    end
  end

  context 'service action' do
    describe 'default' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos',
          version: '6.9'
        ) do |node|
          node.automatic['languages'] = { python: { version: '2.6.2' } }
          node.normal['datadog'] = { api_key: 'somethingnotnil' }
        end.converge described_recipe
      end

      it_behaves_like 'datadog-agent service'
    end

    describe 'agent_enable & agent_start are set to disable, stop' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos',
          version: '6.9'
        ) do |node|
          node.automatic['languages'] = { python: { version: '2.6.2' } }
          node.normal['datadog'] = {
            api_key: 'somethingnotnil',
            agent_enable: false,
            agent_start: false
          }
        end.converge described_recipe
      end

      it 'disables the datadog-agent service' do
        expect(chef_run).to disable_service 'datadog-agent'
      end

      it 'stops the datadog-agent service' do
        expect(chef_run).to stop_service 'datadog-agent'
      end
    end
  end

  context 'agent 6' do
    describe 'the datadog-agent service' do
      context 'on Amazon Linux < 2.0' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            :platform => 'amazon',
            :version => '2017.03'
          ) do |node|
            node.normal['datadog'] = { 'api_key' => 'somethingnotnil', 'agent_major_version' => 6 }
          end.converge described_recipe
        end

        it 'is enabled with Upstart provider' do
          expect(chef_run).to enable_service('datadog-agent').with(
            provider: Chef::Provider::Service::Upstart
          )
        end
      end

      context 'on RHEL 6' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            :platform => 'redhat',
            :version => '6.8'
          ) do |node|
            node.normal['datadog'] = { 'api_key' => 'somethingnotnil', 'agent_major_version' => 6 }
          end.converge described_recipe
        end

        it 'is enabled with Upstart provider' do
          expect(chef_run).to enable_service('datadog-agent').with(
            provider: Chef::Provider::Service::Upstart
          )
        end
      end

      context 'on RHEL 7' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            :platform => 'redhat',
            :version => '7.3'
          ) do |node|
            node.normal['datadog'] = { 'api_key' => 'somethingnotnil', 'agent_major_version' => 6 }
          end.converge described_recipe
        end

        it 'is enabled _without_ Upstart provider' do
          expect(chef_run).to enable_service('datadog-agent')
          expect(chef_run).to_not enable_service('datadog-agent').with(
            provider: Chef::Provider::Service::Upstart
          )
        end
      end
    end

    describe 'the datadog.yaml config file' do
      context 'with default attribute values' do
        context 'on Ubuntu' do
          cached(:chef_run) do
            ChefSpec::SoloRunner.new(
              platform: 'ubuntu',
              version: '14.04'
            ) do |node|
              node.name 'chef-nodename' # expected to be used as the hostname in `datadog.yaml`
              node.normal['datadog'] = { 'api_key' => 'somethingnotnil', 'agent_major_version' => 6 }
            end.converge described_recipe
          end

          it 'is created' do
            expect(chef_run).to create_template('/etc/datadog-agent/datadog.yaml')
          end

          it 'contains expected YAML configuration' do
            expected_yaml = <<-EOF
            api_key: somethingnotnil
            tags: []
            use_dogstatsd: true
            bind_host: localhost
            additional_endpoints: {}
            histogram_aggregates:
              - "max"
              - "median"
              - "avg"
              - "count"
            histogram_percentiles:
              - "0.95"
            hostname: "chef-nodename"
            log_file: "/var/log/datadog/agent.log"
            log_level: "INFO"
            dogstatsd_non_local_traffic: false
            apm_config:
              apm_non_local_traffic: false
            process_config:
              enabled: "false"
              blacklist_patterns: []
              scrub_args: true
              custom_sensitive_words: []
              intervals: {}
              process_dd_url: "https://process.datadoghq.com"
            EOF

            expect(chef_run).to(render_file('/etc/datadog-agent/datadog.yaml').with_content { |content|
              expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
            })
          end
        end

        context 'on Windows' do
          cached(:chef_run) do
            set_env_var('ProgramData', 'C:\ProgramData')
            ChefSpec::SoloRunner.new(
              platform: 'windows',
              version: '2012R2',
              file_cache_path: 'C:/chef/cache'
            ) do |node|
              node.name 'chef-nodename' # expected to be used as the hostname in `datadog.yaml`
              node.normal['datadog'] = { 'api_key' => 'somethingnotnil', 'agent_major_version' => 6 }
            end.converge described_recipe
          end

          temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')
          mock_digest = Digest::SHA256.new

          before do
            allow(File).to receive(:open).and_call_original
            allow(File).to receive(:open).with(temp_file).and_return('foo')
            allow(Digest::SHA256).to receive(:file).and_call_original
            allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
          end

          it 'is created' do
            expect(chef_run).to create_template('C:\ProgramData/Datadog/datadog.yaml')
          end

          it 'contains expected YAML configuration' do
            expected_yaml = <<-EOF
            api_key: somethingnotnil
            tags: []
            use_dogstatsd: true
            bind_host: localhost
            additional_endpoints: {}
            histogram_aggregates:
              - "max"
              - "median"
              - "avg"
              - "count"
            histogram_percentiles:
              - "0.95"
            hostname: "chef-nodename"
            log_level: "INFO"
            dogstatsd_non_local_traffic: false
            apm_config:
              apm_non_local_traffic: false
            process_config:
              enabled: "false"
              blacklist_patterns: []
              scrub_args: true
              custom_sensitive_words: []
              intervals: {}
              process_dd_url: "https://process.datadoghq.com"
            EOF

            expect(chef_run).to(render_file('C:\ProgramData/Datadog/datadog.yaml').with_content { |content|
              expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
            })
          end
        end
      end

      context 'with extra_config params set' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: 'ubuntu',
            version: '14.04'
          ) do |node|
            node.name 'chef-nodename' # expected to be used as the hostname in `datadog.yaml`
            node.normal['datadog'] = {
              'api_key' => 'somethingnotnil',
              'agent_major_version' => 6,
              'extra_config' => {
                'secret_backend_command' => '/sbin/local-secrets',
                'process_config' => {
                  'custom_param' => 'somethingnotnil'
                }
              }
            }
          end.converge described_recipe
        end

        temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')
        mock_digest = Digest::SHA256.new

        before do
          allow(File).to receive(:open).and_call_original
          allow(File).to receive(:open).with(temp_file).and_return('foo')
          allow(Digest::SHA256).to receive(:file).and_call_original
          allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
        end

        it 'is created' do
          expect(chef_run).to create_template('/etc/datadog-agent/datadog.yaml')
        end

        it 'contains expected YAML configuration' do
          expected_yaml = <<-EOF
            api_key: somethingnotnil
            tags: []
            use_dogstatsd: true
            bind_host: localhost
            additional_endpoints: {}
            secret_backend_command: /sbin/local-secrets
            histogram_aggregates:
              - "max"
              - "median"
              - "avg"
              - "count"
            histogram_percentiles:
              - "0.95"
            hostname: "chef-nodename"
            log_file: "/var/log/datadog/agent.log"
            log_level: "INFO"
            dogstatsd_non_local_traffic: false
            apm_config:
              apm_non_local_traffic: false
            process_config:
              enabled: "false"
              blacklist_patterns: []
              scrub_args: true
              custom_sensitive_words: []
              intervals: {}
              process_dd_url: "https://process.datadoghq.com"
              custom_param: somethingnotnil
            EOF

          expect(chef_run).to(render_file('/etc/datadog-agent/datadog.yaml').with_content { |content|
            expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
          })
        end
      end
    end

    describe 'agent version set' do
      context 'on windows' do
        cached(:chef_run) do
          set_env_var('ProgramData', 'C:\ProgramData')
          ChefSpec::SoloRunner.new(
            :platform => 'windows',
            :version => '2012R2',
            :file_cache_path => 'C:/chef/cache'
          ) do |node|
            node.normal['datadog'] = {
              'api_key' => 'somethingnotnil',
              'agent_major_version' => 6,
              'agent_version' => '6.0.3'
            }
          end.converge described_recipe
        end

        temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')
        mock_digest = Digest::SHA256.new

        before do
          allow(File).to receive(:open).and_call_original
          allow(File).to receive(:open).with(temp_file).and_return('foo')
          allow(Digest::SHA256).to receive(:file).and_call_original
          allow(Digest::SHA256).to receive(:file).with(temp_file).and_return(mock_digest)
        end

        it 'installs Datadog Agent' do
          expect(chef_run).to install_windows_package('Datadog Agent').with(installer_type: :msi)
        end

        # remote_file source gets converted to an array, so we need to do
        # some tricky things to be able to regex against it
        # Relevant: http://stackoverflow.com/a/12325983
        it 'installs agent 6.0.3' do
          expect(chef_run.remote_file(temp_file).source.to_s)
            .to match(/ddagent-cli-6.0.3.msi/)
        end
      end

      context 'agent 6 latest on windows' do
        cached(:chef_run) do
          set_env_var('ProgramData', 'C:\ProgramData')
          ChefSpec::SoloRunner.new(
            :platform => 'windows',
            :version => '2012R2',
            :file_cache_path => 'C:/chef/cache'
          ) do |node|
            node.normal['datadog'] = {
              'api_key' => 'somethingnotnil',
              'agent_major_version' => 6,
            }
          end.converge described_recipe
        end

        temp_file = ::File.join('C:/chef/cache', 'ddagent-cli.msi')

        it 'installs Datadog Agent' do
          expect(chef_run).to install_windows_package('Datadog Agent').with(installer_type: :msi)
        end

        # remote_file source gets converted to an array, so we need to do
        # some tricky things to be able to regex against it
        # Relevant: http://stackoverflow.com/a/12325983
        it 'installs agent latest' do
          expect(chef_run.remote_file(temp_file).source.to_s)
            .to match(/datadog-agent-6-latest.amd64.msi/)
        end
      end
    end
  end

  context 'add prefix and suffix to version number in debian' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.normal['datadog'] = {
          'api_key' => 'somethingnotnil',
          'agent_version' => '6.16.0'
        }
      end.converge described_recipe
    end
    it 'installs the full version' do
      expect(chef_run).to install_apt_package('datadog-agent').with_version('1:6.16.0-1')
    end
  end

  context 'add suffix to version number in fedora' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'fedora',
        version: '27'
      ) do |node|
        node.normal['datadog'] = {
          'api_key' => 'somethingnotnil',
          'agent_version' => '6.16.0'
        }
      end.converge described_recipe
    end
    it 'installs the full version' do
      expect(chef_run).to install_yum_package('datadog-agent').with_version('6.16.0-1')
    end
  end
end
