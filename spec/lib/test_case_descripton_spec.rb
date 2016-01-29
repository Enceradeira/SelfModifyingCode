require 'rspec'
require_relative '../../lib/test_case_description'

describe TestCaseDescription do
  let(:desc) { TestCaseDescription }
  describe 'parse' do
    it { expect(desc.parse('00 1->1')).to eq(desc.new([:'00', :'1'], [:'1'])) }
    it { expect(desc.parse('0->1 AF 3')).to eq(desc.new([:'0'], [:'1', :AF, :'3'])) }
    it { expect(desc.parse('->')).to eq(desc.new([], [])) }
    it { expect(desc.parse('3->')).to eq(desc.new([:'3'], [])) }
    it { expect(desc.parse('->3')).to eq(desc.new([], [:'3'])) }
    it { expect(desc.parse('->,')).to eq(desc.new([], [:','])) }
    it { expect(lambda { desc.parse('0 1-1>@') }).to raise_error(StandardError) }
  end
end