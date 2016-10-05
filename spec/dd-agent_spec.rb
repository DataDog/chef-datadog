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
    expect(chef_run).not_to install_apt_package 'datadog-agent'
    expect(chef_run).not_to install_yum_package 'datadog-agent'
  end
end

shared_examples_for 'debianoids repo' do
  it 'installs new apt key' do
    expect(chef_run).to run_execute('apt-key import key 382E94DE').with(
      command: 'apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 A2923DFF56EDA6E76E55E492D3A80E30382E94DE'
    )
  end

  it 'sets up an apt repo' do
    expect(chef_run).to add_apt_repository('datadog')
  end

  it 'installs apt-transport-https' do
    expect(chef_run).to install_package('apt-transport-https')
  end
end

shared_examples_for 'rhellions repo' do
  it 'sets up a yum repo' do
    expect(chef_run).to create_yum_repository('datadog')
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

      it_behaves_like 'debianoids repo'
      it_behaves_like 'debianoids no version set'
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

      it_behaves_like 'debianoids repo'
      it_behaves_like 'debianoids no version set'
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

      it_behaves_like 'debianoids repo'
      it_behaves_like 'debianoids no version set'
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

      it_behaves_like 'rhellions repo'
      it_behaves_like 'rhellions no version set'
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

      it_behaves_like 'rhellions repo'
      it_behaves_like 'rhellions no version set'
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

      it_behaves_like 'rhellions repo'
      it_behaves_like 'rhellions no version set'
    end

    context 'on Windows' do
      cached(:chef_run)  do
        set_env_var('ProgramData', 'C:\ProgramData')
        ChefSpec::SoloRunner.new(
          :platform => 'windows',
          :version => '2012R2',
          :file_cache_path => 'C:/chef/cache'
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
          'agent_version' => '1:5.1.0-440'
        }
        node.set['languages'] = { 'python' => { 'version' => '2.4' } }
      end.converge described_recipe
    end

    it_behaves_like 'debianoids repo'
    it_behaves_like 'debianoids no version set'
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

    it_behaves_like 'debianoids repo'
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

      it_behaves_like 'debianoids repo'
      it_behaves_like 'debianoids no version set'
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
        expect(chef_run).to upgrade_apt_package('datadog-agent')
      end

      it_behaves_like 'debianoids repo'
    end

    context 'allows a string for tags' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        ) do |node|
          node.set['datadog'] = {
            'api_key' => 'somethingnotnil',
            'tags' => 'datacenter:us-foo,database:bar'
          }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources'

      it 'sets tags from the tags attribute' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^tags: datacenter:us-foo,database:bar$/)
      end
    end

    context 'allows key/value for tags' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        ) do |node|
          node.set['datadog'] = {
            'api_key' => 'somethingnotnil',
            'tags' => { 'datacenter' => 'us-foo', 'database' => 'bar' }
          }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources'

      it 'sets tags from the tags attribute' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^tags: datacenter:us-foo,database:bar$/)
      end
    end

    context 'does not use empty tags' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        ) do |node|
          node.set['datadog'] = {
            'api_key' => 'somethingnotnil',
            'tags' => { 'datacenter' => 'us-foo', 'database' => '' }
          }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources'

      it 'sets tags from the tags attribute' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^tags: datacenter:us-foo$/)
      end
    end

    context 'does accept extra endpoints' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'ubuntu',
          version: '12.04'
        ) do |node|
          node.set['datadog'] = {
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
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources'

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
          version: '12.04'
        ) do |node|
          node.set['datadog'] = {
            'api_key' => 'something1',
            'url' => 'https://app.example.com',
            'extra_endpoints' => {
              'example' => {
                'enabled' => true,
                'api_key' => 'something2'
              }
            }
          }
          node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
        end.converge described_recipe
      end

      it_behaves_like 'common linux resources'

      it 'uses the multiples apikeys and urls' do
        expect(chef_run).to render_file('/etc/dd-agent/datadog.conf')
          .with_content(/^api_key: something1,something2$/)
          .with_content(%r{^dd_url: https://app.example.com,https://app.example.com$})
      end
    end
  end

  context 'package downgrade' do
    context 'left to default' do
      context 'on debianoids' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: 'ubuntu',
            version: '12.04'
          ) do |node|
            node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
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
            version: '6.6'
          ) do |node|
            node.set['datadog'] = { 'api_key' => 'somethingnotnil' }
            node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
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
            version: '12.04'
          ) do |node|
            node.set['datadog'] = {
              'api_key' => 'somethingnotnil',
              'agent_allow_downgrade' => true
            }
            node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
          end.converge described_recipe
        end

        it_behaves_like 'common linux resources'
        it_behaves_like 'debianoids no version set'

        it 'allows downgrade' do
          expect(chef_run).to install_apt_package('datadog-agent')
            .with(options: '--force-yes')
        end
      end

      context 'on rhellions' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(
            platform: 'centos',
            version: '6.6'
          ) do |node|
            node.set['datadog'] = {
              'api_key' => 'somethingnotnil',
              'agent_allow_downgrade' => true
            }
            node.set['languages'] = { 'python' => { 'version' => '2.6.2' } }
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
        ChefSpec::SoloRunner.new do |node|
          node.automatic['languages'] = { python: { version: '2.6.2' } }
          node.set['datadog'] = { api_key: 'somethingnotnil' }
        end.converge described_recipe
      end

      it_behaves_like 'datadog-agent service'
    end

    describe 'agent_enable & agent_start are set to disable, stop' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.automatic['languages'] = { python: { version: '2.6.2' } }
          node.set['datadog'] = {
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
end
