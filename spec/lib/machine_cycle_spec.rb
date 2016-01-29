require 'rspec'
require_relative '../../lib/machine_cycle'
require_relative '../../lib/resource_exceeded_error'

describe MachineCycle do
  let (:machine_cycle) { MachineCycle.new(cycle) }
  context 'when 1 machine cycles available' do
    let(:cycle) { 1 }
    describe 'consume_machine_cycle' do
      it 'called once' do
        expect(lambda { machine_cycle.allocate_one }).to_not raise_error
      end
      it 'called twice' do
        machine_cycle.allocate_one
        expect(lambda { machine_cycle.allocate_one }).to raise_error(ResourceExceededError)
      end
    end
  end
end