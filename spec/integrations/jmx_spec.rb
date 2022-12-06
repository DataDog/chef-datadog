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

describe 'datadog::jmx' do
  expected_yaml = <<-EOF
  logs: ~
  init_config:

  instances:
    - host: localhost
      port: 7199
      user: username
      password: password
      name: jmx_instance
      tags:
        env: stage
        newTag: test
      conf:
        - include:
            domain: my_domain
            bean:
              - my_bean
              - my_second_bean
            attribute:
              attribute1:
                metric_type: counter
                alias: jmx.my_metric_name
              attribute2:
                metric_type: gauge
                alias: jmx.my2ndattribute
        - include:
            domain: 2nd_domain
          exclude:
            bean:
              - excluded_bean
        - include:
            domain_regex: regex_on_domain
          exclude:
            bean_regex:
              - regex_on_excluded_bean
  EOF

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'ubuntu',
      version: '16.04',
      step_into: ['datadog_monitor']
    ) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }

      node.normal['datadog'] = {
        'api_key' => 'someapikey',
        'jmx' => {
          'instances' => [
            {
              'host' => 'localhost',
              'port' => 7199,
              'user' => 'username',
              'password' => 'password',
              'name' => 'jmx_instance',
              'tags' => {
                'env' => 'stage',
                'newTag' => 'test'
              },
              'conf' => [
                {
                  'include' => {
                    'domain' => 'my_domain',
                    'bean' => ['my_bean', 'my_second_bean'],
                    'attribute' => {
                      'attribute1' => { 'metric_type' => 'counter', 'alias' => 'jmx.my_metric_name' },
                      'attribute2' => { 'metric_type' => 'gauge', 'alias' => 'jmx.my2ndattribute' }
                    }
                  }
                },
                {
                  'include' => { 'domain' => '2nd_domain' },
                  'exclude' => { 'bean' => ['excluded_bean'] }
                },
                {
                  'include' => { 'domain_regex' => 'regex_on_domain' },
                  'exclude' => { 'bean_regex' => ['regex_on_excluded_bean'] }
                }
              ]
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('jmx') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/jmx.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
