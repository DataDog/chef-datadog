describe 'datadog::repository' do
  context 'on debianoids' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'debian', version: '8.9'
      ).converge(described_recipe)
    end

    it 'include apt cookbook' do
      expect(chef_run).to include_recipe('apt::default')
    end

    it 'installs apt-transport-https' do
      expect(chef_run).to install_package('install-apt-transport-https')
    end

    it 'sets up an apt repo' do
      expect(chef_run).to add_apt_repository('datadog').with(
        key: ['A2923DFF56EDA6E76E55E492D3A80E30382E94DE']
      )
    end

    it 'removes the datadog-beta repo' do
      expect(chef_run).to remove_apt_repository('datadog-beta')
    end
  end

  context 'rhellions' do
    context 'centos 6, agent 7' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos', version: '6.9'
        ) do |node|
          node.normal['datadog'] = { 'agent_major_version' => '7' }
        end.converge(described_recipe)
      end

      it 'sets the yumrepo_gpgkey_new attribute' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new']).to match(
          /DATADOG_RPM_KEY_E09422B3.public/
        )
      end

      it 'installs gnupg' do
        expect(chef_run).to install_package('gnupg')
      end

      it 'downloads the new RPM key' do
        expect(chef_run).to create_remote_file('DATADOG_RPM_KEY_E09422B3.public').with(path: '/var/chef/cache/DATADOG_RPM_KEY_E09422B3.public')
      end

      it 'notifies the GPG key install if a new one is downloaded' do
        keyfile_r = chef_run.remote_file('DATADOG_RPM_KEY_E09422B3.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key e09422b3]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key e09422b3] by default' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key e09422b3')
        expect(keyfile_exec_r).to do_nothing
      end

      # prefer HTTPS on boxes that support TLS1.2
      it 'sets up a yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: 'https://yum.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public'
        )
      end
    end

    context 'centos 6, agent 6' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos', version: '6.9'
        ) do |node|
          node.normal['datadog'] = { 'agent_major_version' => '6' }
        end.converge(described_recipe)
      end

      it 'sets the yumrepo_gpgkey_new attribute' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new']).to match(
          /DATADOG_RPM_KEY_E09422B3.public/
        )
      end

      it 'installs gnupg' do
        expect(chef_run).to install_package('gnupg')
      end

      it 'downloads the new RPM key' do
        expect(chef_run).to create_remote_file('DATADOG_RPM_KEY_E09422B3.public').with(path: '/var/chef/cache/DATADOG_RPM_KEY_E09422B3.public')
      end

      it 'notifies the GPG key install if a new one is downloaded' do
        keyfile_r = chef_run.remote_file('DATADOG_RPM_KEY_E09422B3.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key e09422b3]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key e09422b3] by default' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key e09422b3')
        expect(keyfile_exec_r).to do_nothing
      end

      # prefer HTTPS on boxes that support TLS1.2
      it 'sets up a yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: 'https://yum.datadoghq.com/DATADOG_RPM_KEY.public'
        )
      end
    end

    context 'centos 5, agent 6' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos', version: '5.11'
        ) do |node|
          node.normal['datadog'] = { 'agent_major_version' => '6' }
        end.converge(described_recipe)
      end

      it 'sets the yumrepo_gpgkey_new attribute' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new']).to match(
          /DATADOG_RPM_KEY_E09422B3.public/
        )
      end

      it 'installs gnupg' do
        expect(chef_run).to install_package('gnupg')
      end

      it 'downloads the new RPM key' do
        expect(chef_run).to create_remote_file('DATADOG_RPM_KEY_E09422B3.public').with(path: '/var/chef/cache/DATADOG_RPM_KEY_E09422B3.public')
      end

      it 'notifies the GPG key install if a new one is downloaded' do
        keyfile_r = chef_run.remote_file('DATADOG_RPM_KEY_E09422B3.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key e09422b3]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key e09422b3] by default' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key e09422b3')
        expect(keyfile_exec_r).to do_nothing
      end

      # RHEL5 has to use insecure HTTP due to lack of support for TLS1.2
      # https://github.com/DataDog/chef-datadog/blob/v2.8.1/attributes/default.rb#L85-L91
      it 'sets up a yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: 'http://yum.datadoghq.com/DATADOG_RPM_KEY.public'
        )
      end
    end
  end
end
