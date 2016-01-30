require 'rspec'
require_relative '../../lib/enumerable'

describe Enumerable do
  let(:sample) { [2, 4, 4, 4, 5, 5, 7, 9] }
  describe 'mean' do
    it { expect(sample.mean).to eq(5) }
  end

  describe 'standard_deviation' do
    it { expect(sample.standard_deviation).to be_within(0.001).of(2.138) }
  end


end