require 'spec_helper'

describe 'datadog::dd-agent' do

  # This recipe needs to have an api_key, otherwise `raise` is called.
  # It also depends on specific platofrm versions for software install
  before do
    Fauxhai.mock(platform:'ubuntu', version:'12.04') do |node|
      node['datadog'] = {:api_key => "somethingnotnil"}
    end
  end

  let (:runner) { ChefSpec::ChefRunner.new.converge 'datadog::dd-agent' }

  it 'should install the datadog-agent' do
    runner.should install_package 'datadog-agent'
  end
  
  it 'should enable the datadog-agent service' do
    runner.should set_service_to_start_on_boot 'datadog-agent'
  end

  it 'should ensure the dd-agent directory exists' do
    runner.should create_directory '/etc/dd-agent'
  end

  it 'should drop an agent config file' do
    runner.should create_file '/etc/dd-agent/datadog.conf'
  end

end
