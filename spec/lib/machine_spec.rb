require 'rspec'
require_relative 'source_repository'
require_relative '../../lib/machine'
require_relative '../../lib/tape'
require_relative '../../lib/resources'
require_relative '../../lib/resource_exceeded_error'

describe Machine do
  describe 'execute' do
    let(:resources) { Resources.new }
    context 'program and' do
      let(:program) { SourceRepository.and }

      context 'when resources available' do
        it { expect(Machine.execute(%w(0 0), program, resources)).to eq([:'0']) }
        it { expect(Machine.execute(%w(0 1), program, resources)).to eq([:'0']) }
        it { expect(Machine.execute(%w(1 0), program, resources)).to eq([:'0']) }
        it { expect(Machine.execute(%w(1 1), program, resources)).to eq([:'1']) }
      end

      context 'when no machine_cycles available' do
        let(:resources) { Resources.new { |r| r.machine_cycles = 0 } }
        it { expect(lambda { Machine.execute(%w(1 1), program, resources) }).to raise_error(ResourceExceededError) }
      end

      context 'when machine_cycles_per_execution is too small' do
        let(:resources) { Resources.new { |r| r.machine_cycles_per_execution = 0 } }
        it { expect(lambda { Machine.execute(%w(1 1), program, resources) }).to raise_error(ResourceExceededError) }
      end

    end

    context 'program or' do
      let(:program) { SourceRepository.or }
      it { expect(Machine.execute(%w(0 0), program, resources)).to eq([:'0']) }
      it { expect(Machine.execute(%w(0 1), program, resources)).to eq([:'1']) }
      it { expect(Machine.execute(%w(1 0), program, resources)).to eq([:'1']) }
      it { expect(Machine.execute(%w(1 1), program, resources)).to eq([:'1']) }
    end

    context 'program erase_tape' do
      let(:program) { SourceRepository.erase_tape }
      it { expect(Machine.execute(%w(0), program, resources)).to eq([]) }
      it { expect(Machine.execute(%w(0 1), program, resources)).to eq([]) }
      it { expect(Machine.execute(%w(2 A 45), program, resources)).to eq([]) }
    end

  end
end