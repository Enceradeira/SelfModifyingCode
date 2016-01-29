require 'rspec'
require_relative '../../lib/resources'
require_relative '../../lib/resource_exceeded_error'

describe Resources do
  let(:resources) { Resources.new { |r| r.machine_cycles = machine_cycles } }
  let(:machine_cycles) { 100 }
  context 'when unlimited machine cycle available' do
    let(:machine_cycles) { UNLIMITED_MACHINE_CYCLES }
    it 'called once' do
      expect(lambda { resources.allocate_machine_cycle }).to_not raise_error
    end
    it 'called several times' do
      expect(lambda { 5.times { resources.allocate_machine_cycle } }).to_not raise_error
    end
  end
  context 'when 1 machine cycles available' do
    let(:machine_cycles) { 1 }
    describe 'consume_machine_cycle' do
      it 'called once' do
        expect(lambda { resources.allocate_machine_cycle }).to_not raise_error
      end
      it 'called twice' do
        resources.allocate_machine_cycle
        expect(lambda { resources.allocate_machine_cycle }).to raise_error(ResourceExceededError)
      end
    end
  end
end