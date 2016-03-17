require_relative 'numeric_gene'
require_relative 'state_table_rows_gene'
require_relative 'state_table_row'
require_relative 'state_transition'
require_relative 'mutation'

class Chromosome< Struct.new(
    :nr_states, :rows_gene)

  def initialize(nr_states, rows_gene)
    self.nr_states = nr_states
    self.rows_gene = rows_gene
  end

  public
  class << self
    def create
      nr_states = NumericGene.new(0)
      state_table_rows_gene = StateTableRowsGene.create
      Chromosome.new(nr_states, state_table_rows_gene)
    end
  end

  def decode
    self.rows_gene.rows
  end

  def mutate
    mutation = Mutation.new
    mutation.register(self.nr_states)
    mutation.register(self.rows_gene)

    genes = mutation.execute
    Chromosome.new(*genes)
  end
end