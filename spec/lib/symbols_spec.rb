require 'rspec'
require_relative '../../lib/symbols'
require_relative '../../lib/test_case'

describe Symbols do
  let(:symbols) { Symbols.new(test_cases) }

  context 'when no output defined' do
    let(:test_cases) { [TestCase.new('H->'), TestCase.new('1->')] }
    describe 'for_output' do
      it { expect(symbols.for_output).to contain_exactly(nil) }
    end
    describe ' for_input' do
      it { expect(symbols.for_input).to contain_exactly(:H, :'1', nil) }
    end
  end

  context 'when no input defined' do
    let(:test_cases) { [TestCase.new('->'), TestCase.new('->AG')] }
    describe 'for_output' do
      it { expect(symbols.for_output).to contain_exactly(:AG, nil) }
    end
    describe ' for_input' do
      it { expect(symbols.for_input).to contain_exactly(nil) }
    end
  end

  context 'when input and output defined' do
    let(:test_cases) { [TestCase.new('a b->D A'), TestCase.new('a c->D F')] }
    describe 'for_output' do
      it { expect(symbols.for_output).to contain_exactly(:A, :D, :F, nil) }
    end
    describe ' for_input' do
      it { expect(symbols.for_input).to contain_exactly(:a, :b, :c, nil) }
    end
  end
end