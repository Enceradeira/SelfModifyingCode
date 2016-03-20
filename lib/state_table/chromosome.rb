require_relative 'numeric_gene'
require_relative 'state_table_row_gene'
require_relative 'mutation'
require_relative 'vocabulary'

class Chromosome
  private
  def initialize(nr_rows_gene, rows_genes, nr_states_gene, vocabulary)
    nr_rows_value = nr_rows_gene.value
    rows_genes_count = rows_genes.count
    if nr_rows_value != rows_genes_count
      raise StandardError.new "nr_rows_gene was #{nr_rows_value} but rows_genes had #{rows_genes_count} elements"
    end
    @nr_rows_gene = nr_rows_gene
    @rows_genes = rows_genes
    @nr_states_gene = nr_states_gene
    @vocabulary = vocabulary
  end

  def mutate_rows(nr_rows_gene, rows_genes)
    nr_rows_diff = nr_rows_gene.value - @nr_rows_gene.value
    if nr_rows_diff > 0
      nr_rows_diff.times.each do
        if block_given?
          new_gene = yield
        else
          new_gene = StateTableRowGene.create(@vocabulary)
        end
        index = Randomizer.rand(rows_genes.count)
        rows_genes.insert(index, new_gene)
      end
    elsif nr_rows_diff < 0
      (-1*nr_rows_diff).times.each do
        index = Randomizer.rand(rows_genes.count-1)
        rows_genes.delete_at(index)
      end
    end
  end

  protected
  attr_reader :nr_rows_gene, :rows_genes

  public
  class << self
    def create(symbols)
      nr_rows_gene=NumericGene.new
      nr_states_gene=NumericGene.new
      vocabulary = Vocabulary.new(nr_states_gene.value, symbols)
      rows = nr_rows_gene.value.times.map { |_| StateTableRowGene.create(vocabulary) }
      Chromosome.new(nr_rows_gene, rows, nr_states_gene, vocabulary )
    end
  end

  def decode
    @rows_genes.map { |g| g.decode }
  end

  def mutate
    mutation = Mutation.new
    mutation.register(@nr_rows_gene)
    mutation.register(@nr_states_gene)
    @rows_genes.each { |g| mutation.register(g) }

    mutations = mutation.execute(@vocabulary)
    nr_rows_gene = mutations[0]
    nr_state_gene = mutations[1]
    rows_genes = mutations.drop(2)

    mutate_rows(nr_rows_gene, rows_genes)
    vocabulary = @vocabulary.mutate(nr_state_gene.value)

    Chromosome.new(nr_rows_gene, rows_genes, nr_state_gene, vocabulary)
  end


end