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

require 'spec_helper'

# Importing apt_sources_list_file variable from recipe_helpers.rb
apt_sources_list_file = Chef::Datadog.apt_sources_list_file

describe 'datadog::remove-dd-agent' do
  context 'when on Ubuntu' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge(described_recipe) }

    it 'purges the datadog-agent package' do
      expect(chef_run).to purge_package('datadog-agent')
    end

    it 'removes apt_sources_list_file and purges the datadog-signing-keys package' do
      expect(chef_run).to purge_apt_package('datadog-signing-keys')
      expect(chef_run).to delete_file(apt_sources_list_file)
    end
  end

  context 'when on Amazon Linux' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'amazon', version: '2').converge(described_recipe) }

    it 'purges the datadog-agent package' do
      expect(chef_run).to purge_package('datadog-agent')
    end

    it 'removes the datadog yum repository' do
      expect(chef_run).to remove_yum_repository('datadog')
    end
  end

  context 'when on Suse' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'suse', version: '12.5').converge(described_recipe) }

    it 'purges the datadog-agent package' do
      expect(chef_run).to purge_package('datadog-agent')
    end

    it 'removes the datadog zypper repository' do
      expect(chef_run).to remove_zypper_repository('datadog')
    end
  end

  context 'when on Windows' do
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'windows', version: '2016').converge(described_recipe) }

    it 'removes the Datadog Agent package' do
      expect(chef_run).to remove_package('Datadog Agent')
    end
  end
end
