require 'rspec'
require_relative '../../lib/program_factory'
require_relative '../../lib/machine'

describe ProgramFactory do
  let(:factory) { ProgramFactory.new }
  describe 'build' do
    it 'constructs AND program' do
      test_cases = %w(
        0,1->0
        1,0->0
        0,0->0
        1,1->1
      )
      source = factory.build(test_cases)
      expect(Machine.execute(%w(0 0), source)).to eq(['0'])
      expect(Machine.execute(%w(1 0), source)).to eq(['0'])
      expect(Machine.execute(%w(0 1), source)).to eq(['0'])
      expect(Machine.execute(%w(1 1), source)).to eq(['1'])
    end
  end
end