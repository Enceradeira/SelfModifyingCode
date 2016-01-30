require 'rspec'
require_relative '../../lib/resources'
require_relative '../../lib/resource_exceeded_error'

describe Resources do
  let(:resources) { Resources.new { |r| r.machine_cycles = machine_cycles } }
  let(:machine_cycles) { 100 }

  describe 'create_statistic' do
    it 'prints statistic' do
      cycle1 = resources.create_machine_cycles
      cycle1.allocate_one
      cycle1.allocate_one
      cycle2 = resources.create_machine_cycles
      cycle2.allocate_one

      string = resources.create_statistic
      expect(string).to eq('Total machine cycles:     3
Total machine executions: 2')
    end
  end
end