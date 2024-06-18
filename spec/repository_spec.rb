# Copyright:: 2011-Present, Datadog
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

shared_examples 'old debianoid' do
  it 'properly creates both keyring files and imports all keys' do
    expect(chef_run).to create_file_if_missing('/usr/share/keyrings/datadog-archive-keyring.gpg')
    expect(chef_run).to create_remote_file('/etc/apt/trusted.gpg.d/datadog-archive-keyring.gpg').with(
      source: 'file:///usr/share/keyrings/datadog-archive-keyring.gpg')
    expect(chef_run).to create_file('/etc/apt/sources.list.d/datadog.list').with(
      content: 'deb [signed-by=/usr/share/keyrings/datadog-archive-keyring.gpg] https://apt.datadoghq.com stable 7'
    )

    # NOTE: there is no way in chefspec to actually test the notified action,
    # see https://github.com/chefspec/chefspec/issues/541
    expect(chef_run.remote_file('remote_file_DATADOG_APT_KEY_CURRENT.public')).to notify(
      'execute[import apt datadog key DATADOG_APT_KEY_CURRENT.public]').to(:run).immediately
    expect(chef_run.remote_file('remote_file_D18886567EABAD8B2D2526900D826EB906462314')).to notify(
      'execute[import apt datadog key D18886567EABAD8B2D2526900D826EB906462314]').to(:run).immediately
    expect(chef_run.remote_file('remote_file_5F1E256061D813B125E156E8E6266D4AC0962C7D')).to notify(
      'execute[import apt datadog key 5F1E256061D813B125E156E8E6266D4AC0962C7D]').to(:run).immediately
    expect(chef_run.remote_file('remote_file_D75CEA17048B9ACBF186794B32637D44F14F620E')).to notify(
      'execute[import apt datadog key D75CEA17048B9ACBF186794B32637D44F14F620E]').to(:run).immediately
    expect(chef_run.remote_file('remote_file_A2923DFF56EDA6E76E55E492D3A80E30382E94DE')).to notify(
      'execute[import apt datadog key A2923DFF56EDA6E76E55E492D3A80E30382E94DE]').to(:run).immediately
  end
end

shared_examples 'new debianoid' do
  it 'properly creates the keyring file and imports all keys' do
    expect(chef_run).to create_file_if_missing('/usr/share/keyrings/datadog-archive-keyring.gpg')
    expect(chef_run).to_not create_remote_file('/etc/apt/trusted.gpg.d/datadog-archive-keyring.gpg')
    expect(chef_run).to create_file('/etc/apt/sources.list.d/datadog.list').with(
      content: 'deb [signed-by=/usr/share/keyrings/datadog-archive-keyring.gpg] https://apt.datadoghq.com stable 7'
    )

    expect(chef_run.remote_file('remote_file_DATADOG_APT_KEY_CURRENT.public')).to notify(
      'execute[import apt datadog key DATADOG_APT_KEY_CURRENT.public]').to(:run).immediately
    expect(chef_run.remote_file('remote_file_D18886567EABAD8B2D2526900D826EB906462314')).to notify(
      'execute[import apt datadog key D18886567EABAD8B2D2526900D826EB906462314]').to(:run).immediately
    expect(chef_run.remote_file('remote_file_5F1E256061D813B125E156E8E6266D4AC0962C7D')).to notify(
      'execute[import apt datadog key 5F1E256061D813B125E156E8E6266D4AC0962C7D]').to(:run).immediately
    expect(chef_run.remote_file('remote_file_D75CEA17048B9ACBF186794B32637D44F14F620E')).to notify(
      'execute[import apt datadog key D75CEA17048B9ACBF186794B32637D44F14F620E]').to(:run).immediately
    expect(chef_run.remote_file('remote_file_A2923DFF56EDA6E76E55E492D3A80E30382E94DE')).to notify(
      'execute[import apt datadog key A2923DFF56EDA6E76E55E492D3A80E30382E94DE]').to(:run).immediately
  end
end

def import_gpg_keys(key_list, install_gnupg = true)
  key_list.each do |key|
    unless key.eql? 'current'
      set_yum_repo_and_gnupg(key, install_gnupg)
    end

    it "downloads the #{key} RPM key" do
      expect(chef_run).to create_remote_file("remote_file_DATADOG_RPM_KEY_#{key.upcase}.public").with(path: ::File.join(Chef::Config[:file_cache_path], "DATADOG_RPM_KEY_#{key.upcase}.public"))
    end

    it "notifies the GPG key install if a new one is downloaded #{key.upcase}" do
      keyfile_r = chef_run.remote_file("remote_file_DATADOG_RPM_KEY_#{key.upcase}.public")
      expect(keyfile_r).to notify("execute[rpm-import datadog key #{key}]")
        .to(:run).immediately
    end

    if key.eql? 'current'
      it 'execute[rpm-import datadog key *] by default CURRENT' do
        keyfile_exec_r = chef_run.execute('rpm-import datadog key current')
        expect(keyfile_exec_r).to do_nothing
      end
    else
      it "doesn\'t execute[rpm-import datadog key *] by default #{key.upcase}" do
        keyfile_exec_r = chef_run.execute("rpm-import datadog key #{key}")
        expect(keyfile_exec_r).to do_nothing
      end
    end
  end
end

def set_yum_repo_and_gnupg(key, install_gnupg)
  it "sets the yumrepo_gpgkey_new attribute #{key}" do
    expect(chef_run.node['datadog']["yumrepo_gpgkey_new_#{key}"]).to match(
      /DATADOG_RPM_KEY_#{key.upcase}.public/
    )
  end

  if install_gnupg
    it "installs gnupg #{key.upcase}" do
      expect(chef_run).to install_package('gnupg') if chef_run.node['packages']['gnupg2'].nil?
    end
  end
end

describe 'datadog::repository' do
  context 'on debianoids' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'debian', version: '8.11'
      ).converge(described_recipe)
    end

    it 'include apt cookbook' do
      expect(chef_run).to periodic_apt_update('update')
    end

    it 'installs apt-transport-https' do
      expect(chef_run).to install_package('install-apt-transport-https')
    end

    # testing of creation of the source file + keyrings is done for various cases in different methods

    it 'removes the datadog-beta repo' do
      expect(chef_run).to remove_apt_repository('datadog-beta')
    end

    it 'removes the datadog_apt_D75CEA17048B9ACBF186794B32637D44F14F620E repo' do
      expect(chef_run).to remove_apt_repository('datadog_apt_D75CEA17048B9ACBF186794B32637D44F14F620E')
    end

    it 'removes the datadog_apt_A2923DFF56EDA6E76E55E492D3A80E30382E94DE repo' do
      expect(chef_run).to remove_apt_repository('datadog_apt_A2923DFF56EDA6E76E55E492D3A80E30382E94DE')
    end
  end

  context 'debian < 9' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        # Fauxhai doesn't have definition for Debian < 9, but we can
        # workaround that by setting platform_version below
        platform: 'debian', version: '9.11'
      ) do |node|
        node.automatic['platform_version'] = '8.0'
      end.converge(described_recipe)
    end

    it_behaves_like 'old debianoid'
  end

  context 'ubuntu < 16' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu', version: '14.04'
      ).converge(described_recipe)
    end

    it_behaves_like 'old debianoid'
  end

  context 'debian >= 9' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'debian', version: '9.11'
      ).converge(described_recipe)
    end

    it_behaves_like 'new debianoid'
  end

  context 'ubuntu >= 16' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu', version: '16.04'
      ).converge(described_recipe)
    end

    it_behaves_like 'new debianoid'
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

      # Key B01082D3 (from 2023-04-20 to 2028-04-18)
      # Key FD4BF915 (from 2020-09-08 to 2024-09-07)
      # Key E09422B3
      import_gpg_keys(
        %w[current 4f09d16b b01082d3 fd4bf915 e09422b3]
      )

      # prefer HTTPS on boxes that support TLS1.2
      it 'sets up a yum repo E09422B3, FD4BF915 and B01082D3' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: [
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_4F09D16B.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_B01082D3.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public',
          ]
        ).with(repo_gpgcheck: true)
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

      # Key B01082D3 (from 2023-04-20 to 2028-04-18)
      # Key FD4BF915 (from 2020-09-08 to 2024-09-07)
      # Key E09422B3
      import_gpg_keys([
        '4f09d16b',
        'b01082d3',
        'fd4bf915',
        'e09422b3'
      ])

      # prefer HTTPS on boxes that support TLS1.2
      it 'sets up a yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: [
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_4F09D16B.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_B01082D3.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public',
          ]
        ).with(repo_gpgcheck: true)
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

      # Key B01082D3 (from 2023-04-20 to 2028-04-18)
      # Key FD4BF915 (from 2020-09-08 to 2024-09-07)
      # Key E09422B3
      import_gpg_keys([
        '4f09d16b',
        'b01082d3',
        'fd4bf915',
        'e09422b3'
      ])

      # RHEL5 has to use insecure HTTP due to lack of support for TLS1.2
      # https://github.com/DataDog/chef-datadog/blob/v2.8.1/attributes/default.rb#L85-L91
      it 'sets up a yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: [
            'http://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public',
            'http://keys.datadoghq.com/DATADOG_RPM_KEY_4F09D16B.public',
            'http://keys.datadoghq.com/DATADOG_RPM_KEY_B01082D3.public',
            'http://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public',
            'http://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public',
          ]
        ).with(repo_gpgcheck: false)
      end
    end

    context 'centos 8.1, agent 6' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos', version: '8'
        ) do |node|
          node.normal['datadog'] = { 'agent_major_version' => '6' }
          node.automatic['platform_version'] = '8.1'
        end.converge(described_recipe)
      end

      it 'disables repo_gpgcheck because of dnf bug in RHEL 8.1' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: [
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_4F09D16B.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_B01082D3.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public',
          ]
        ).with(repo_gpgcheck: false)
      end
    end

    context 'centos 8.2, agent 6' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'centos', version: '8'
        ) do |node|
          node.normal['datadog'] = { 'agent_major_version' => '6' }
          node.automatic['platform_version'] = '8.2'
        end.converge(described_recipe)
      end

      it 'enables repo_gpgcheck because of fixed dnf bug in RHEL 8.2' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: [
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_4F09D16B.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_B01082D3.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public',
          ]
        ).with(repo_gpgcheck: true)
      end
    end

    context 'almalinux 8.5, agent 6', if: min_chef_version('17.0.69') do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'almalinux', version: '8'
        ) do |node|
          node.normal['datadog'] = { 'agent_major_version' => '6' }
          node.automatic['platform_version'] = '8.5'
        end.converge(described_recipe)
      end

      it 'sets up the yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: [
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_4F09D16B.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_B01082D3.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public',
          ]
        ).with(repo_gpgcheck: true)
      end
    end

    context 'rocky 8.5, agent 6', if: min_chef_version('17.1.35') do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'rocky', version: '8'
        ) do |node|
          node.normal['datadog'] = { 'agent_major_version' => '6' }
          node.automatic['platform_version'] = '8.5'
        end.converge(described_recipe)
      end

      it 'sets up the yum repo' do
        expect(chef_run).to create_yum_repository('datadog').with(
          gpgkey: [
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_4F09D16B.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_B01082D3.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_FD4BF915.public',
            'https://keys.datadoghq.com/DATADOG_RPM_KEY_E09422B3.public',
          ]
        ).with(repo_gpgcheck: true)
      end
    end
  end

  context 'suseiods' do
    # SUSE 12.5 is one of the versions for which we want to generate gpgkey=
    # entry in repofile with one value; ensure this stays true even if
    # https://github.com/chef/chef/issues/11090 (specifying multiple values for
    # gpgkey= entry) is implemented and used here in the future
    context 'suse 12.5, agent 6' do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          platform: 'suse', version: '12.5'
        ) do |node|
          node.normal['datadog'] = { 'agent_major_version' => '6' }
        end.converge(described_recipe)
      end

      import_gpg_keys([
        '4f09d16b',
        'b01082d3',
        'fd4bf915',
        'e09422b3'
      ], false)

      it 'deletes the old RPM GPG key 4172a230 if it exists' do
        expect(chef_run).to run_execute('rpm-remove old gpg key 4172a230-55dd14f6')
          .with(command: 'rpm --erase gpg-pubkey-4172a230-55dd14f6')
      end

      it 'sets up a yum repo' do
        # Since Chef 17, the gpgkey field is automatically converted into an
        # array by the zypper_repository resource.
        if Gem::Version.new(Chef::VERSION) >= Gem::Version.new(17)
          expect(chef_run).to create_zypper_repository('datadog').with(
            gpgkey: ['https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public']
          )
        else
          expect(chef_run).to create_zypper_repository('datadog').with(
            gpgkey: 'https://keys.datadoghq.com/DATADOG_RPM_KEY_CURRENT.public'
          )
        end
      end
    end
  end
end
