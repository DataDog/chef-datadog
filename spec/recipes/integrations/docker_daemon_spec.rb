describe 'datadog::docker_daemon' do
  expected_yaml = <<-EOF
    logs: ~
    init_config:
      docker_root: /
      timeout: 10
      tls: false
      tls_client_cert: /path/to/client-cert.pem
      tls_client_key: /path/to/client-key.pem
      tls_cacert: /path/to/ca.pem
      tls_verify: true
    instances:
      - url: unix://var/run/docker.sock
        tags:
          - toto
          - tata
        include:
          - docker_image:ubuntu
          - docker_image:debian
        exclude:
          - .*
        performance_tags:
          - container_name
          - image_name
          - image_tag
          - docker_image
        container_tags:
          - image_name
          - image_tag
          - docker_image
        collect_labels_as_tags:
          - com.docker.compose.service
          - com.docker.compose.project
        ecs_tags: true
        collect_events: true
        collect_container_size: false
        collect_image_size: false
        collect_images_stats: false
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
        'docker_daemon' => {
          init_config: {
            docker_root: '/',
            timeout: 10,
            tls: false,
            tls_client_cert: '/path/to/client-cert.pem',
            tls_client_key: '/path/to/client-key.pem',
            tls_cacert: '/path/to/ca.pem',
            tls_verify: true
          },
          instances: [
            {
              url: 'unix://var/run/docker.sock',
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
              performance_tags: [
                'container_name',
                'image_name',
                'image_tag',
                'docker_image'
              ],
              container_tags: [
                'image_name',
                'image_tag',
                'docker_image'
              ],
              collect_labels_as_tags: [
                'com.docker.compose.service',
                'com.docker.compose.project'
              ],
              ecs_tags: true,
              collect_events: true,
              collect_container_size: false,
              collect_image_size: false,
              collect_images_stats: false
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('docker_daemon') }

  it { is_expected.to manage_group('docker').with(append: true, members: ['dd-agent']) }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/docker_daemon.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(YAML.safe_load(expected_yaml).to_json)
    })
  end
end
