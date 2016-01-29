require 'rspec'
require_relative '../../lib/machine_cycles'
require_relative '../../lib/machine_cycle'
require_relative '../../lib/resource_exceeded_error'


describe MachineCycles do
  let(:machine_cycles) { MachineCycles.new(MachineCycle.new(cycles), MachineCycle.new(cycles_per_execution)) }
  describe 'allocate_one' do
    context 'when 2 cycles and 2 cycles_per_execution available' do
      let(:cycles) { 2 }
      let(:cycles_per_execution) { 2 }

      it 'called once' do
        expect(lambda { machine_cycles.allocate_one }).to_not raise_error
      end

      it 'called twice' do
        expect(lambda { 2.times { machine_cycles.allocate_one } }).to_not raise_error
      end

      it 'called three times' do
        expect(lambda { 3.times { machine_cycles.allocate_one } }).to raise_error(ResourceExceededError)
      end
    end

    context 'when 3 cycles and 2 cycles_per_execution available' do
      let(:cycles) { 3 }
      let(:cycles_per_execution) { 2 }

      it 'called twice' do
        expect(lambda { 2.times { machine_cycles.allocate_one } }).to_not raise_error
      end

      it 'called three times' do
        expect(lambda { 3.times { machine_cycles.allocate_one } }).to raise_error(ResourceExceededError)
      end
    end

    context 'when 2 cycles and 3 cycles_per_execution available' do
      let(:cycles) { 2 }
      let(:cycles_per_execution) { 3 }

      it 'called twice' do
        expect(lambda { 2.times { machine_cycles.allocate_one } }).to_not raise_error
      end

      it 'called three times' do
        expect(lambda { 3.times { machine_cycles.allocate_one } }).to raise_error(ResourceExceededError)
      end
    end
  end
end