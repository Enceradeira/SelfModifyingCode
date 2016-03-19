require 'rspec'
require_relative '../../../lib/state_table/numeric_gene'

describe NumericGene do

  let(:nr_tested_examples) { 100 }
  let(:gene) { NumericGene.new }

  describe 'value' do
    it { expect(gene.value).to eq(0) }
  end

  describe 'mutate' do
    it 'mutates value by setting a single bit' do
      values = nr_tested_examples.times.map do
        mutation1 = gene.mutate
        mutation2 = mutation1.mutate
        {:mutation1 => mutation1.value, :mutation2 => mutation2.value}
      end

      # e.g 0001 ^ 0101 = 0100 (xor) which tells which bit has been set between mutation1 and mutation2
      values_xor = values.map do |t|
        t[:mutation1] ^ t[:mutation2]
      end

      # since only one bit should have been set by mutation2 all xor'ed values should be dividable by 2
      all_diff_by_one_bit = values_xor.all? { |v| v == 1 || (v % 2)==0 }
      expect(all_diff_by_one_bit).to be_truthy
    end
    it 'mutates by a random value' do
      values = nr_tested_examples.times.map { gene.mutate.value }.uniq
      expect(values.count).to be > 1
    end
  end
end