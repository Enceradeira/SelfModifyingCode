require 'rspec'
require_relative '../../lib/test_case'
require_relative '../../lib/resources'
require_relative 'source_repository'
require_relative '../../lib/resource_exceeded_error'

describe TestCase do
  let(:and_program) { Program.compile(SourceRepository.and) }
  let(:or_program) { Program.compile(SourceRepository.or) }
  let(:erase_program) { Program.compile(SourceRepository.erase_tape) }
  let(:empty_program) { Program.compile(SourceRepository.empty) }
  let(:ambiguous_program) { Program.compile(SourceRepository.ambiguous_code) }
  let(:indefinite_recursion_program) { Program.compile(SourceRepository.indefinite_recursion) }
  let(:max_nr_machine_cycles_per_execution) { 1000 }
  let(:resources) { Resources.new { |r|
    r.machine_cycles = machine_cycles
    r.machine_cycles_per_execution = max_nr_machine_cycles_per_execution } }
  describe 'passes_for?' do
    context 'when unlimited machine cycles available' do
      let(:machine_cycles) { UNLIMITED_MACHINE_CYCLES }
      context '0 1->1' do
        let(:test_case) { TestCase.new('0 1->1') }
        it { expect(test_case.passes_for?(and_program, resources)[:is_ok]).to be_falsey }
        it { expect(test_case.passes_for?(or_program, resources)[:is_ok]).to be_truthy }
        it { expect(test_case.passes_for?(empty_program, resources)[:is_ok]).to be_falsey }
        it { expect(test_case.passes_for?(ambiguous_program, resources)[:is_ok]).to be_falsey }
        it { expect(test_case.passes_for?(indefinite_recursion_program, resources)[:is_ok]).to be_falsey }
        it { expect(test_case.passes_for?(indefinite_recursion_program, resources)[:used_machine_cycles]).to eq(max_nr_machine_cycles_per_execution) }
      end
      context '0 1->0' do
        let(:test_case) { TestCase.new('0 1->0') }
        it { expect(test_case.passes_for?(and_program, resources)[:is_ok]).to be_truthy }
        it { expect(test_case.passes_for?(and_program, resources)[:used_machine_cycles]).to eq(2) }
        it { expect(test_case.passes_for?(erase_program, resources)[:is_ok]).to be_falsey }
        it { expect(test_case.passes_for?(erase_program, resources)[:used_machine_cycles]).to eq(3) }
        it { expect(test_case.passes_for?(or_program, resources)[:is_ok]).to be_falsey }
        it { expect(test_case.passes_for?(or_program, resources)[:used_machine_cycles]).to eq(2) }
      end
      context 'A C->' do
        let(:test_case) { TestCase.new('A C->') }
        it { expect(test_case.passes_for?(and_program, resources)[:is_ok]).to be_falsey }
        it { expect(test_case.passes_for?(or_program, resources)[:is_ok]).to be_falsey }
        it { expect(test_case.passes_for?(erase_program, resources)[:is_ok]).to be_truthy }
      end
    end
    context 'when 5 machine_cycles available' do
      let(:machine_cycles) { 5 }
      context '0 1->1' do
        let(:test_case) { TestCase.new('0 1->1') }
        it { expect(lambda { test_case.passes_for?(indefinite_recursion_program, resources) }).to raise_error(ResourceExceededError) }
      end
    end
  end
end