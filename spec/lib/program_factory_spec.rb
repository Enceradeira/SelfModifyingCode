require 'rspec'
require_relative '../../lib/program_factory'
require_relative '../../lib/machine'
require_relative '../../lib/resources'

describe ProgramFactory do
  let(:factory) { ProgramFactory.new(resources) }
  let(:resources) { Resources.new { |r|
    r.machine_cycles = 1000000
    r.machine_cycles_per_execution = 1000
  } }
  describe 'build' do

    it 'constructs AND program' do
      test_cases = [
          '0 1->0',
          '1 0->0',
          '0 0->0',
          '1 1->1',
      ]

      source = factory.build(test_cases)
      expect(Machine.execute(%w(0 0), source, resources)).to eq([:'0'])
      expect(Machine.execute(%w(1 0), source, resources)).to eq([:'0'])
      expect(Machine.execute(%w(0 1), source, resources)).to eq([:'0'])
      expect(Machine.execute(%w(1 1), source, resources)).to eq([:'1'])
    end

    it 'constructs addition program' do
      test_cases = [
          '0 0 0 0->0 0 0',
          '0 0 0 1->0 0 1',
          '0 0 1 0->0 1 0',
          '0 0 1 1->0 1 1',
          '0 1 0 0->0 0 1',
          '0 1 0 1->0 1 0',
          '0 1 1 0->0 1 1',
          '0 1 1 1->1 0 0',
          '1 0 0 0->0 1 0',
          '1 0 0 1->0 1 1',
          '1 0 1 0->1 0 0',
          '1 0 1 1->1 0 1',
          '1 1 0 0->0 1 1',
          '1 1 0 1->1 0 0',
          '1 1 1 0->1 0 1',
          '1 1 1 1->1 1 0']

      source = factory.build(test_cases)
      expect(Machine.execute(%w(0 0 0 0), source, resources)).to eq(%w(0 0 0))
      expect(Machine.execute(%w(0 0 0 1), source, resources)).to eq(%w(0 0 1))
      expect(Machine.execute(%w(0 0 1 0), source, resources)).to eq(%w(0 1 0))
      expect(Machine.execute(%w(0 0 1 1), source, resources)).to eq(%w(0 1 1))
      expect(Machine.execute(%w(0 1 0 0), source, resources)).to eq(%w(0 0 1))
      expect(Machine.execute(%w(0 1 0 1), source, resources)).to eq(%w(0 1 0))
      expect(Machine.execute(%w(0 1 1 0), source, resources)).to eq(%w(0 1 1))
      expect(Machine.execute(%w(0 1 1 1), source, resources)).to eq(%w(1 0 0))
      expect(Machine.execute(%w(1 0 0 0), source, resources)).to eq(%w(0 1 0))
      expect(Machine.execute(%w(1 0 0 1), source, resources)).to eq(%w(0 1 1))
      expect(Machine.execute(%w(1 0 1 0), source, resources)).to eq(%w(1 0 0))
      expect(Machine.execute(%w(1 0 1 1), source, resources)).to eq(%w(1 0 1))
      expect(Machine.execute(%w(1 1 0 0), source, resources)).to eq(%w(0 1 1))
      expect(Machine.execute(%w(1 1 0 1), source, resources)).to eq(%w(1 0 0))
      expect(Machine.execute(%w(1 1 1 0), source, resources)).to eq(%w(1 0 1))
      expect(Machine.execute(%w(1 1 1 1), source, resources)).to eq(%w(1 1 0))
    end
  end
end