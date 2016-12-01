describe 'datadog::rabbitmq' do
  expected_yaml = <<-EOF
    init_config:

    instances:
      - rabbitmq_api_url: http://localhost:15672/api/
        rabbitmq_user: guest
        rabbitmq_pass: guest
        ssl_verify: true
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
    ChefSpec::SoloRunner.new(step_into: ['datadog_monitor']) do |node|
      node.automatic['languages'] = { 'python' => { 'version' => '2.7.2' } }
      node.set['datadog'] = {
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
    expect(chef_run).to render_file('/etc/dd-agent/conf.d/rabbitmq.yaml').with_content { |content|
      expect(YAML.load(content).to_json).to be_json_eql(YAML.load(expected_yaml).to_json)
    }
  end
end
