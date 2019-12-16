# Encoding: utf-8

require 'spec_helper'

AGENT_CONFIG = File.join(@agent_config_dir, 'conf.d/docker.d/conf.yaml')

describe service(@agent_service_name) do
  it { should be_running }
end

describe file(AGENT_CONFIG) do
  it { should be_a_file }

  it 'is valid yaml matching input values' do
    generated = YAML.load_file(AGENT_CONFIG)

    expected = {
      instances: [
        {
          url: 'unix://var/run/docker.sock',
          tag_by_command: false,
          new_tag_names: false,
          tags: [
            'toto',
            'tata'
          ],
          include: [
            'docker_image:ubuntu',
            'docker_image:debian'
          ],
          exclude: [
            '.*'
          ],
          collect_events: true,
          collect_container_size: false,
          collect_all_metrics: false,
          collect_images_stats: false
        }
      ],
      'logs' => nil,
      init_config: {
        docker_root: '/',
        socket_timeout: 10
      }
    }

    expect(generated.to_json).to be_json_eql expected.to_json
  end
end
