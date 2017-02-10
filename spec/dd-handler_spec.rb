require 'spec_helper'

shared_examples 'a chef-handler-datadog installer' do |version|
  it 'includes chef_handler recipe' do
    expect(chef_run).to include_recipe('chef_handler')
  end

  it 'installs the right version of chef-handler-datadog' do
    expect(chef_run).to install_chef_gem('chef-handler-datadog').with(version: version)
  end
end

shared_examples 'a chef-handler-datadog runner' do |extra_endpoints, tags_blacklist_regex|
  it 'runs the handler' do
    handler_config = {
      api_key: 'somethingnotnil',
      application_key: 'somethingnotnil2',
      use_ec2_instance_id: true,
      tag_prefix: 'tag:',
      url: 'https://app.datadoghq.com',
      extra_endpoints: extra_endpoints || [],
      tags_blacklist_regex: tags_blacklist_regex
    }

    expect(chef_run).to enable_chef_handler('Chef::Handler::Datadog').with(
      source: 'chef/handler/datadog',
      arguments: [handler_config]
    )
  end
end

describe 'datadog::dd-handler' do
  context 'standard usage' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.set['datadog']['api_key'] = 'somethingnotnil'
        node.set['datadog']['application_key'] = 'somethingnotnil2'
        node.set['datadog']['chef_handler_enable'] = true
        node.set['datadog']['use_ec2_instance_id'] = true
      end.converge described_recipe
    end

    it_behaves_like 'a chef-handler-datadog installer'

    it_behaves_like 'a chef-handler-datadog runner'
  end

  context 'handler disabled' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.set['datadog']['api_key'] = 'somethingnotnil'
        node.set['datadog']['application_key'] = 'somethingnotnil2'
        node.set['datadog']['chef_handler_enable'] = false
        node.set['datadog']['use_ec2_instance_id'] = true
      end.converge described_recipe
    end

    it_behaves_like 'a chef-handler-datadog installer'

    it "doesn't enable the datadog handler" do
      expect(chef_run).not_to enable_chef_handler 'Chef::Handler::Datadog'
    end
  end

  context 'with api and app keys set as node attributes and on node run_state' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.set['datadog']['api_key'] = 'api_overriden_by_run_state'
        node.set['datadog']['application_key'] = 'app_overriden_by_run_state'
        node.set['datadog']['chef_handler_enable'] = true
        node.set['datadog']['use_ec2_instance_id'] = true
        node.run_state['datadog'] = {
          'api_key' => 'somethingnotnil',
          'application_key' => 'somethingnotnil2'
        }
      end.converge described_recipe
    end

    it_behaves_like 'a chef-handler-datadog installer'

    it_behaves_like 'a chef-handler-datadog runner'
  end

  context 'with keys set on node run_state only' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.set['datadog']['chef_handler_enable'] = true
        node.set['datadog']['use_ec2_instance_id'] = true
        node.run_state['datadog'] = {
          'api_key' => 'somethingnotnil',
          'application_key' => 'somethingnotnil2'
        }
      end.converge described_recipe
    end

    it_behaves_like 'a chef-handler-datadog installer'

    it_behaves_like 'a chef-handler-datadog runner'
  end

  context 'multiple endpoints' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.set['datadog']['api_key'] = 'somethingnotnil'
        node.set['datadog']['application_key'] = 'somethingnotnil2'
        node.set['datadog']['chef_handler_enable'] = true
        node.set['datadog']['use_ec2_instance_id'] = true
        node.set['datadog']['extra_endpoints']['qqqq']['enabled'] = true
        node.set['datadog']['extra_endpoints']['qqqq']['api_key'] = 'something'
        node.set['datadog']['extra_endpoints']['qqqq']['application_key'] = 'something2'
      end.converge described_recipe
    end

    extra_endpoints = [
      Mash.new(api_key: 'something',
               application_key: 'something2')
    ]

    it_behaves_like 'a chef-handler-datadog installer'

    it_behaves_like 'a chef-handler-datadog runner', extra_endpoints, nil
  end

  context 'multiple endpoints disabled' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.set['datadog']['api_key'] = 'somethingnotnil'
        node.set['datadog']['application_key'] = 'somethingnotnil2'
        node.set['datadog']['chef_handler_enable'] = true
        node.set['datadog']['use_ec2_instance_id'] = true
        node.set['datadog']['extra_endpoints']['qqqq']['enabled'] = false
        node.set['datadog']['extra_endpoints']['qqqq']['api_key'] = 'something'
        node.set['datadog']['extra_endpoints']['qqqq']['application_key'] = 'something2'
      end.converge described_recipe
    end

    it_behaves_like 'a chef-handler-datadog installer'

    it_behaves_like 'a chef-handler-datadog runner'
  end

  context 'tags_blacklist_regex set' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(
        platform: 'ubuntu',
        version: '14.04'
      ) do |node|
        node.set['datadog']['api_key'] = 'somethingnotnil'
        node.set['datadog']['application_key'] = 'somethingnotnil2'
        node.set['datadog']['chef_handler_enable'] = true
        node.set['datadog']['use_ec2_instance_id'] = true
        node.set['datadog']['tags_blacklist_regex'] = 'tags.*'
      end.converge described_recipe
    end

    it_behaves_like 'a chef-handler-datadog installer'

    it_behaves_like 'a chef-handler-datadog runner', nil, 'tags.*'
  end
end
