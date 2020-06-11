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
        allow(File).to receive(:exist?).and_return(false)
        allow(File)
          .to receive(:exist?)
          .with('C:/Program Files/Datadog/Datadog Agent/bin/agent')
          .and_return(true)

        # stub agent status call
        allow_any_instance_of(Module)
          .to receive(:`)
          .with('"C:/Program Files/Datadog/Datadog Agent/bin/agent" status')
          .and_return(agent_status)
      end

      let(:agent_status) do
        %(
.....
Agent (v6.20.0)
....
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
        let(:agent_status) do
          %(
.....
Agent (v6.20.0-devel+git.38.cd7f989)
....
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
