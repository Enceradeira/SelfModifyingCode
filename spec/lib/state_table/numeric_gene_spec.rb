require 'rspec'
require_relative '../../../lib/state_table/numeric_gene'

describe NumericGene do
  let(:gene) { NumericGene.new(max) }

  describe 'value' do

    [1, 10].each do |m|
      context "when max is #{m}" do
        let(:max) { m }
        context 'called 10 times' do
          let(:values) { 10.times.map { NumericGene.new(max).value } }

          it { expect(values).to all (be >= 0) }
          it { expect(values).to all (be <= max) }
          it { expect(values.uniq.count).to be > 1 }
        end

        it 'return same value when called repetitively' do
          expect(gene.value).to eq(gene.value)
        end
      end

      it { expect(NumericGene.new(0).value).to be==0 }
    end
  end

  describe 'mutate' do
    def select_twice_mutated_gene(&block)
      mutated_genes_sample.select do |g|
        nr_samples.times.map { g.mutate.value }.all?(&block)
      end
    end

    let(:max) { 2 }
    let(:nr_samples) { 100 }
    let (:mutated_genes_sample) { nr_samples.times.map { gene.mutate } }

    it { expect(gene.mutate).to be_a(NumericGene) }
    it 'always returns new value' do
      new_values = mutated_genes_sample.map { |g| g.value }
      expect(new_values.select { |v| v==gene.value }).to be_empty
    end

    it 'increases max by 1' do
      values = mutated_genes_sample.map { |g| g.value }.uniq
      expect(values).to match_array([0, 1, 2, 3].reject{|v| v==gene.value})
    end

    context 'called twice' do
      it 'increases max by 2' do
        values = mutated_genes_sample.map{ |g |g.mutate }.map { |g| g.value }.uniq
        expect(values).to contain_exactly(0, 1, 2, 3, 4)
      end
    end

  end
end