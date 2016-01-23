require 'rspec'
require_relative 'source_repository'
require_relative '../../lib/machine'
require_relative '../../lib/tape'

describe Machine do
  let(:machine) { Machine.new(tape, program) }
  context 'and' do
    let(:program) { SourceRepository.and }
    it { expect(Machine.execute(%w(0 0), program)).to eq(%w(0)) }
    it { expect(Machine.execute(%w(0 1), program)).to eq(%w(0)) }
    it { expect(Machine.execute(%w(1 0), program)).to eq(%w(0)) }
    it { expect(Machine.execute(%w(1 1), program)).to eq(%w(1)) }
  end

  context 'or' do
    let(:program) { SourceRepository.or }
    it { expect(Machine.execute(%w(0 0), program)).to eq(%w(0)) }
    it { expect(Machine.execute(%w(0 1), program)).to eq(%w(1)) }
    it { expect(Machine.execute(%w(1 0), program)).to eq(%w(1)) }
    it { expect(Machine.execute(%w(1 1), program)).to eq(%w(1)) }
  end

  context 'erase_tape' do
    let(:program) { SourceRepository.erase_tape }
    it { expect(Machine.execute(%w(0), program)).to eq([]) }
    it { expect(Machine.execute(%w(0 1), program)).to eq([]) }
    it { expect(Machine.execute(%w(2 A 45), program)).to eq([]) }
  end
end
