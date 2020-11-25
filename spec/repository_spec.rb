describe 'datadog::repository' do
  context 'on debianoids' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'debian', version: '8.9'
      ).converge(described_recipe)
    end

    it 'include apt cookbook' do
      expect(chef_run).to periodic_apt_update('update')
    end

    it 'installs apt-transport-https' do
      expect(chef_run).to install_package('install-apt-transport-https')
    end

    it 'sets up an apt repo with fingerprint A2923DFF56EDA6E76E55E492D3A80E30382E94DE' do
      expect(chef_run).to add_apt_repository('datadog_apt_A2923DFF56EDA6E76E55E492D3A80E30382E94DE').with(
        key: ['A2923DFF56EDA6E76E55E492D3A80E30382E94DE']
      )
    end

    it 'sets up an apt repo with fingerprint D75CEA17048B9ACBF186794B32637D44F14F620E' do
      expect(chef_run).to add_apt_repository('datadog_apt_D75CEA17048B9ACBF186794B32637D44F14F620E').with(
        key: ['D75CEA17048B9ACBF186794B32637D44F14F620E']
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

      # Key E09422B3
      it 'sets the yumrepo_gpgkey_new attribute E09422B3' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new_e09422b3']).to match(
          /DATADOG_RPM_KEY_E09422B3.public/
        )
      end

      it 'installs gnupg E09422B3' do
        expect(chef_run).to install_package('gnupg') if chef_run.node['packages']['gnupg2'].nil?
      end

      it 'downloads the new RPM key E09422B3' do
        expect(chef_run).to create_remote_file('remote_file_DATADOG_RPM_KEY_E09422B3.public').with(path: ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY_E09422B3.public'))
      end

      it 'notifies the GPG key install if a new one is downloaded E09422B3' do
        keyfile_r = chef_run.remote_file('remote_file_DATADOG_RPM_KEY_E09422B3.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key e09422b3]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key *] by default E09422B3' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key e09422b3')
        expect(keyfile_exec_r).to do_nothing
      end

      # Key FD4BF915 (2020-09-08)
      it 'sets the yumrepo_gpgkey_new attribute fd4bf915' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new_fd4bf915']).to match(
          /DATADOG_RPM_KEY_20200908.public/
        )
      end

      it 'installs fd4bf915' do
        expect(chef_run).to install_package('gnupg') if chef_run.node['packages']['gnupg2'].nil?
      end

      it 'downloads the new RPM key fd4bf915' do
        expect(chef_run).to create_remote_file('remote_file_DATADOG_RPM_KEY_20200908.public').with(path: ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY_20200908.public'))
      end

      it 'notifies the GPG key install if a new one is downloaded fd4bf915' do
        keyfile_r = chef_run.remote_file('remote_file_DATADOG_RPM_KEY_20200908.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key fd4bf915]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key *] by default fd4bf915' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key fd4bf915')
        expect(keyfile_exec_r).to do_nothing
      end

      # prefer HTTPS on boxes that support TLS1.2
      it 'sets up a yum repo E09422B3 and 20200908' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: ['https://yum.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public', 'https://yum.datadoghq.com/DATADOG_RPM_KEY_20200908.public']
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

      # Key E09422B3
      it 'sets the yumrepo_gpgkey_new attribute E09422B3' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new_e09422b3']).to match(
          /DATADOG_RPM_KEY_E09422B3.public/
        )
      end

      it 'installs gnupg E09422B3' do
        expect(chef_run).to install_package('gnupg') if chef_run.node['packages']['gnupg2'].nil?
      end

      it 'downloads the new RPM key E09422B3' do
        expect(chef_run).to create_remote_file('remote_file_DATADOG_RPM_KEY_E09422B3.public').with(path: ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY_E09422B3.public'))
      end

      it 'notifies the GPG key install if a new one is downloaded E09422B3' do
        keyfile_r = chef_run.remote_file('remote_file_DATADOG_RPM_KEY_E09422B3.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key e09422b3]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key *] by default E09422B3' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key e09422b3')
        expect(keyfile_exec_r).to do_nothing
      end

      # Key FD4BF915 (2020-09-08)
      it 'sets the yumrepo_gpgkey_new attribute fd4bf915' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new_fd4bf915']).to match(
          /DATADOG_RPM_KEY_20200908.public/
        )
      end

      it 'installs gnupg fd4bf915' do
        expect(chef_run).to install_package('gnupg') if chef_run.node['packages']['gnupg2'].nil?
      end

      it 'downloads the new RPM key fd4bf915' do
        expect(chef_run).to create_remote_file('remote_file_DATADOG_RPM_KEY_20200908.public').with(path: ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY_20200908.public'))
      end

      it 'notifies the GPG key install if a new one is downloaded fd4bf915' do
        keyfile_r = chef_run.remote_file('remote_file_DATADOG_RPM_KEY_20200908.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key fd4bf915]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key *] by default fd4bf915' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key fd4bf915')
        expect(keyfile_exec_r).to do_nothing
      end

      # prefer HTTPS on boxes that support TLS1.2
      it 'sets up a yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: ['https://yum.datadoghq.com/DATADOG_RPM_KEY.public']
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

      # Key E09422B3
      it 'sets the yumrepo_gpgkey_new attribute E09422B3' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new_e09422b3']).to match(
          /DATADOG_RPM_KEY_E09422B3.public/
        )
      end

      it 'installs gnupg' do
        expect(chef_run).to install_package('gnupg') if chef_run.node['packages']['gnupg2'].nil?
      end

      it 'downloads the new RPM key E09422B3' do
        expect(chef_run).to create_remote_file('remote_file_DATADOG_RPM_KEY_E09422B3.public').with(path: ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY_E09422B3.public'))
      end

      it 'notifies the GPG key install if a new one is downloaded E09422B3' do
        keyfile_r = chef_run.remote_file('remote_file_DATADOG_RPM_KEY_E09422B3.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key e09422b3]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key *] by default E09422B3' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key e09422b3')
        expect(keyfile_exec_r).to do_nothing
      end

      # Key FD4BF915 (2020-09-08)
      it 'sets the yumrepo_gpgkey_new attribute fd4bf915' do
        expect(chef_run.node['datadog']['yumrepo_gpgkey_new_fd4bf915']).to match(
          /DATADOG_RPM_KEY_20200908.public/
        )
      end

      it 'installs gnupg' do
        expect(chef_run).to install_package('gnupg') if chef_run.node['packages']['gnupg2'].nil?
      end

      it 'downloads the new RPM key fd4bf915' do
        expect(chef_run).to create_remote_file('remote_file_DATADOG_RPM_KEY_20200908.public').with(path: ::File.join(Chef::Config[:file_cache_path], 'DATADOG_RPM_KEY_20200908.public'))
      end

      it 'notifies the GPG key install if a new one is downloaded fd4bf915' do
        keyfile_r = chef_run.remote_file('remote_file_DATADOG_RPM_KEY_20200908.public')
        expect(keyfile_r).to notify('execute[rpm-import datadog key fd4bf915]')
          .to(:run).immediately
      end

      it 'doesn\'t execute[rpm-import datadog key *] by default fd4bf915' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key fd4bf915')
        expect(keyfile_exec_r).to do_nothing
      end

      # RHEL5 has to use insecure HTTP due to lack of support for TLS1.2
      # https://github.com/DataDog/chef-datadog/blob/v2.8.1/attributes/default.rb#L85-L91
      it 'sets up a yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: ['http://yum.datadoghq.com/DATADOG_RPM_KEY.public']
        )
      end
    end
  end
end
