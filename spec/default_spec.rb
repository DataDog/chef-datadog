require 'spec_helper'

describe 'datadog::default' do

  context 'when converging this recipe' do

    let(:chef_run) { ChefSpec::ChefRunner.new.converge 'datadog::default' }

    it 'should do nothing' do
    end

  end

end
