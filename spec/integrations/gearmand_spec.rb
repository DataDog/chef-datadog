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

describe 'datadog::gearmand' do
  expected_yaml = <<-EOF
  logs:

  instances:
  - server: 127.0.0.1
    port: 4730
    tasks:
    - TASK_1
    - TASK_2
    tags:
    - <KEY_1>:<VALUE_1>
    - <KEY_2>:<VALUE_2>
    service: <SERVICE>
    min_collection_interval: 60
    empty_default_hostname: true
    metric_patterns:
      include:
      - <INCLUDE_REGEX>
      exclude:
      - <EXCLUDE_REGEX>

  init_config:
  # No init_config details needed
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['datadog_monitor']
    ) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
      node.normal['datadog'] = {
        api_key: 'someapikey',
        gearmand: {
          instances: [
            {
              server: '127.0.0.1',
              port: '4730',
              tasks: [
                'TASK_1',
                'TASK_2',
              ],
              tags: [
                '<KEY_1>:<VALUE_1>',
                '<KEY_2>:<VALUE_2>'
              ],
              service: '<SERVICE>',
              # Defaults to 15 if not set
              min_collection_interval: 60,
              # Defaults to false if not set
              empty_default_hostname: true,
              metric_patterns: {
                include: [
                  '<INCLUDE_REGEX>'
                ],
                exclude: [
                  '<EXCLUDE_REGEX>'
                ]
              }
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('gearmand') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/gearmand.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
