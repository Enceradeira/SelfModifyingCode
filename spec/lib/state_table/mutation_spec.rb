require 'rspec'
require_relative '../../../lib/state_table/mutation'
require_relative 'numeric_gene_stub'

describe Mutation do
  let(:mutation) { Mutation.new }
  let(:vocabulary) { Object.new }

  context 'one gene registered' do
    let(:gene) { NumericGeneStub.new(3, 5) }
    before(:each) do
      mutation.register(gene)
    end

    describe 'execute' do
      it 'mutates only gene' do
        expect(mutation.execute(vocabulary)).to eq([NumericGeneStub.new(5, 5)])
      end
    end

  end
  context 'several genes registered' do
    let(:gene1) { NumericGeneStub.new(3, 5) }
    let(:gene2) { NumericGeneStub.new(4, 6) }
    let(:gene3) { NumericGeneStub.new(5, 7) }
    before(:each) do
      mutation.register(gene1)
      mutation.register(gene2)
      mutation.register(gene3)
    end

    it 'mutates exactly one gene' do
      mutated_genes = mutation.execute(vocabulary)
      is_gene1_changed = mutated_genes[0].eql?(NumericGeneStub.new(5, 5))
      is_gene2_changed = mutated_genes[1].eql?(NumericGeneStub.new(6, 6))
      is_gene3_changed = mutated_genes[2].eql?(NumericGeneStub.new(7, 7))
      expect((is_gene1_changed ^ is_gene2_changed ^ is_gene3_changed) &&
                 !(is_gene1_changed && is_gene2_changed && is_gene3_changed)).to be_truthy
    end
  end
end