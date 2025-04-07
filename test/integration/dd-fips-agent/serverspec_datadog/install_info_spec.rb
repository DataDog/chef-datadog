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

@agent_package_name = 'datadog-iot-agent'

describe 'Install infos' do
  let(:install_info_path) do
    if os == :windows
      "#{ENV['ProgramData']}\\Datadog\\install_info"
    else
      '/etc/datadog-agent/install_info'
    end
  end

  let(:install_info) do
    YAML.load_file(install_info_path)
  end

  it 'adds an install_info' do
    expect(install_info['install_method']).to match(
      'tool_version' => /chef-\d+\.\d+\.\d+/,
      'tool' => 'chef',
      'installer_version' => /^datadog_cookbook-\d+\.\d+\.\d+$/
    )
  end
end
