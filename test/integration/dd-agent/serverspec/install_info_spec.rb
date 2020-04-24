require 'spec_helper'

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
