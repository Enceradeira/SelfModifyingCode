require_relative 'numeric_gene'
require_relative 'state_table_row_gene'
require_relative 'mutation'

class StateTableRowsGene
  private
  def initialize(nr_rows_gene, rows_genes)
    nr_rows_value = nr_rows_gene.value
    rows_genes_count = rows_genes.count
    if nr_rows_value != rows_genes_count
      raise StandardError.new "nr_rows_gene was #{nr_rows_value} but rows_genes had #{rows_genes_count} elements"
    end
    @nr_rows_gene = nr_rows_gene
    @rows_genes = rows_genes
  end

  protected
  attr_reader :nr_rows_gene, :rows_genes

  public
  class << self
    def create(nr_rows_gene=NumericGene.new)
      rows = nr_rows_gene.value.times.map { |_| StateTableRowGene.create }
      StateTableRowsGene.new(nr_rows_gene, rows)
    end
  end

  def decode
    @rows_genes.map { |g| g.decode }
  end

  def mutate
    mutation = Mutation.new
    mutation.register(@nr_rows_gene)
    @rows_genes.each { |g| mutation.register(g) }

    mutations = mutation.execute
    nr_rows_gene = mutations.shift

    nr_rows_diff = nr_rows_gene.value - @nr_rows_gene.value
    if nr_rows_diff > 0
      nr_rows_diff.times.each do
        if block_given?
          new_gene = yield
        else
          new_gene = StateTableRowsGene.create
        end
        index = Randomizer.rand(mutations.count)
        mutations.insert(index, new_gene)
      end
    elsif nr_rows_diff < 0
      (-1*nr_rows_diff).times.each do
        index = Randomizer.rand(mutations.count-1)
        mutations.delete_at(index)
      end
    end

    StateTableRowsGene.new(nr_rows_gene, mutations)
  end

end