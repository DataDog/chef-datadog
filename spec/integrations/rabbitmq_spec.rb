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

describe 'datadog::rabbitmq' do
  expected_yaml = <<-EOF
    logs: ~
    init_config:

    instances:
      - rabbitmq_api_url: http://localhost:15672/api/
        rabbitmq_user: guest
        rabbitmq_pass: guest
        ssl_verify: true
        tag_families: false
        tags:
          - optional_tag1
          - optional_tag2
        nodes:
          - rabbit@localhost
          - rabbit2@domain
        nodes_regexes:
          - bla.*
        queues:
          - queue1
          - queue2
        queues_regexes:
          - thisqueue-.*
          - another_\\d+queue
        vhosts:
          - vhost1
          - vhost2
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
        rabbitmq: {
          instances: [
            {
              api_url: 'http://localhost:15672/api/',
              user: 'guest',
              pass: 'guest',
              tags: ['optional_tag1', 'optional_tag2'],
              nodes: ['rabbit@localhost', 'rabbit2@domain'],
              nodes_regexes: ['bla.*'],
              queues: ['queue1', 'queue2'],
              queues_regexes: ['thisqueue-.*', 'another_\\d+queue'],
              vhosts: ['vhost1', 'vhost2']
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('rabbitmq') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/rabbitmq.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
