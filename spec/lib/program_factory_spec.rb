require 'rspec'
require_relative '../../lib/program_factory'
require_relative '../../lib/machine'
require_relative '../../lib/resources'
require_relative '../../lib/enumerable'

describe ProgramFactory do
  let(:factory) { ProgramFactory.new(resources) }
  let(:machine_cycles) { 1000000 }
  let(:machine_cycles_per_execution) { 1000 }
  let(:resources) { Resources.new { |r|
    r.machine_cycles = machine_cycles
    r.machine_cycles_per_execution = machine_cycles_per_execution
  } }

  describe 'build' do
    let(:test_cases) { [
        '0 1->0',
        '1 0->0',
        '0 0->0',
        '1 1->1',
    ] }

    context 'with test_cases for AND' do

      it 'constructs AND program' do
        source = factory.build(test_cases)
        expect(Machine.execute(%w(0 0), source, resources)).to eq([:'0'])
        expect(Machine.execute(%w(1 0), source, resources)).to eq([:'0'])
        expect(Machine.execute(%w(0 1), source, resources)).to eq([:'0'])
        expect(Machine.execute(%w(1 1), source, resources)).to eq([:'1'])

        puts resources.create_statistic
      end

      it 'constructs AND program efficiently', :performance => true do
        nr_cycles = 100.times.map do
          resources_for_run = Resources.new { |r|
            r.machine_cycles = machine_cycles
            r.machine_cycles_per_execution = machine_cycles_per_execution
          }
          ProgramFactory.new(resources_for_run).build(test_cases)
          resources_for_run.total_machine_cycles
        end
        puts "Total machine cycles average:            #{nr_cycles.mean}"
        puts "Total machine cycles standard deviation: #{nr_cycles.standard_deviation}"
      end
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

      puts resources.create_statistic
    end
  end
end