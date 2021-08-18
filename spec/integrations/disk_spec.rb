describe 'datadog::disk' do
  expected_yaml = <<-EOF
  logs: ~
  init_config: ~

  instances:
    - use_mount: true
      excluded_filesystems:
        - tmpfs
      excluded_disks:
        - /dev/sda1
        - /dev/sda2
      excluded_disk_re: '/dev/sde.*'
      tag_by_filesystem: false
      excluded_mountpoint_re: '/mnt/somebody-elses-problem.*'
      all_partitions: false
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
        disk: {
          instances: [
            {
              use_mount: true,
              excluded_filesystems: ['tmpfs'],
              excluded_disks: ['/dev/sda1', '/dev/sda2'],
              excluded_disk_re: '/dev/sde.*',
              tag_by_filesystem: false,
              excluded_mountpoint_re: '/mnt/somebody-elses-problem.*',
              all_partitions: false
            }
          ]
        }
      }
    end.converge(described_recipe)
  end

  subject { chef_run }

  it_behaves_like 'datadog-agent'

  it { is_expected.to include_recipe('datadog::dd-agent') }

  it { is_expected.to add_datadog_monitor('disk') }

  it 'renders expected YAML config file' do
    expect(chef_run).to(render_file('/etc/datadog-agent/conf.d/disk.d/conf.yaml').with_content { |content|
      expect(YAML.safe_load(content).to_json).to be_json_eql(
        YAML.safe_load(expected_yaml).to_json
      )
    })
  end
end
