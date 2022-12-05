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
    let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '20.04').converge(described_recipe) }

    it 'removes the Datadog Agent package'
        expect(chef_run).to remove_package('datadog-agent')
    end

    it 'removes apt_sources_list_file and the datadog-signing-keys package'
        expect(chef_run).to remove_apt_package('datadog-signing-keys')
        expect(chef_run).to delete_file(apt_sources_list_file)
    end

    # let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'amazon', version: '2.0').converge(described_recipe) }

    # it 'removes the Datadog Agent package'
    #     expect(chef_run).to remove_package('datadog-agent')
    # end

    # it 'removes the Datadog yum repository'
    #     expect(chef_run).to remove_yum_repository('datadog')
    # end

    # let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'suse', version: '12.5').converge(described_recipe) }

    # it 'removes the Datadog Agent package'
    #     expect(chef_run).to remove_package('datadog-agent')
    # end

    # it 'removes the Datadog yum repository'
    #     expect(chef_run).to remove_zypper_repository('datadog')
    # end
end
