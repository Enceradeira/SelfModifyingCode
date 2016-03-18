require_relative 'numeric_gene'
require_relative 'state_table_row_gene'
require_relative 'mutation'

class StateTableRowsGene < Struct.new(
    :rows_genes, :nr_rows_gene)
  private
  def initialize(nr_rows_gene, rows_genes)
    self.nr_rows_gene = nr_rows_gene
    self.rows_genes = rows_genes

  end

  public
  class << self
    def create(nr_rows_gene=NumericGene.new(1))
      rows = nr_rows_gene.value.times.map { |_| StateTableRowGene.create }
      StateTableRowsGene.new(nr_rows_gene, rows)
    end
  end

  def mutate
    mutation = Mutation.new
    mutation.register(self.nr_rows_gene)
    self.rows_genes.each { |g| mutation.register(g) }

    mutations = mutation.execute
    first = mutations.shift
    StateTableRowsGene.new(first, mutations)
  end

end