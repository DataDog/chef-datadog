require 'spec_helper'

require_relative '../libraries/recipe_helpers'

describe Chef::Datadog::WindowsInstallHelpers do
  describe '#must_reinstall?' do
    before do
      stub_const('Chef::VERSION', chef_version)
      allow(Chef::Datadog).to receive(:agent_version).with(node).and_return(requested_agent_version)
    end

    let(:node) do
      {}
    end

    let(:requested_agent_version) do
      '6.20.0'
    end

    let(:chef_version) do
      '14.0.0'
    end

    context 'when the agent is not installed' do
      before do
        allow(File)
          .to receive(:exist?)
          .with('C:/Program Files/Datadog/Datadog Agent/bin/agent')
          .and_return(false)
      end

      it 'returns false' do
        expect(described_class.must_reinstall?(node)).to be false
      end
    end

    context 'when the agent is installed' do
      before do
        allow(Chef::Datadog::WindowsInstallHelpers)
          .to receive(:agent_get_version)
          .and_return(agent_version_string)
      end

      let(:agent_version_string) do
        %(
Agent 6.20.0 - Commit: 3c29612 - Serialization version: v5.0.22 - Go version: go1.17.11
        )
      end

      context 'when the agent version requested is greater than the installed version' do
        let(:requested_agent_version) do
          '6.21.0'
        end

        it 'returns false' do
          expect(described_class.must_reinstall?(node)).to be false
        end
      end

      context 'when the agent version requested is lesser than the installed version' do
        let(:requested_agent_version) do
          '6.17.0'
        end

        it 'returns true' do
          expect(described_class.must_reinstall?(node)).to be true
        end
      end

      context 'when the current agent version is a nightly' do
        let(:agent_get_version) do
          %(
Agent 6.20.0-devel - Meta: git.38.cd7f989 - Commit: cd7f98964 - Serialization version: v5.0.22 - Go version: go1.17.11
          )
        end

        it 'returns false' do
          expect(described_class.must_reinstall?(node)).to be false
        end
      end

      context 'when the chef version cannot reinstall the agent (registry key problem)' do
        let(:chef_version) do
          '13.0.0'
        end

        it 'returns false' do
          expect(described_class.must_reinstall?(node)).to be false
        end
      end
    end
  end
end
