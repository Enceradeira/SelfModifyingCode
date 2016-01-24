require 'rspec'
require_relative '../../lib/test_case_description'

describe TestCaseDescription do
  let(:desc) { TestCaseDescription }
  describe 'parse' do
    it { expect(desc.parse('00 1->1')).to eq(desc.new(%w(00 1), %w(1))) }
    it { expect(desc.parse('0->1 AF 3')).to eq(desc.new(%w(0), %w(1 AF 3))) }
    it { expect(desc.parse('->')).to eq(desc.new(%w(), %w())) }
    it { expect(desc.parse('3->')).to eq(desc.new(%w(3), %w())) }
    it { expect(desc.parse('->3')).to eq(desc.new(%w(), %w(3))) }
    it { expect(desc.parse('->,')).to eq(desc.new(%w(), %w(,))) }
    it { expect(lambda { desc.parse('0 1-1>@') }).to raise_error(StandardError) }
  end
end