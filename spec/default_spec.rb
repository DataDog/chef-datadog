require 'spec_helper'

describe 'datadog::default' do
  context 'when converging this recipe' do
    let(:chef_run) { ChefSpec::SoloRunner.converge described_recipe }

    it 'should do nothing' do
    end
  end
end
