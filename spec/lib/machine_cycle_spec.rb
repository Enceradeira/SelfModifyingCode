require 'rspec'
require_relative '../../lib/machine_cycle'
require_relative '../../lib/resource_exceeded_error'

describe MachineCycle do
  let (:machine_cycle) { MachineCycle.new(cycle) }
  context 'when 1 machine cycles available' do
    let(:cycle) { 1 }
    describe 'allocate_one' do
      it 'does not raise exception when called once' do
        expect(lambda { machine_cycle.allocate_one }).to_not raise_error
      end
      it 'does raise exception when called twice' do
        machine_cycle.allocate_one
        expect(lambda { machine_cycle.allocate_one }).to raise_error(ResourceExceededError)
      end
    end

    describe 'used_machine_cycles' do
      it { expect(machine_cycle.used_machine_cycles).to eq(0) }
      it do
        machine_cycle.allocate_one
        expect(machine_cycle.used_machine_cycles).to eq(1)
      end
    end
  end
end