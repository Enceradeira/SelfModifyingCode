require_relative 'numeric_gene'
require_relative 'state_table_rows_gene'
require_relative 'state_table_row'
require_relative 'state_transition'
require_relative 'mutation'

class Chromosome
  private
  def initialize(nr_states, rows_gene)
    @nr_states = nr_states
    @rows_gene = rows_gene
  end

  protected
  attr_reader :nr_states,:rows_gene

  public
  class << self
    def create
      nr_states = NumericGene.new
      state_table_rows_gene = StateTableRowsGene.create
      Chromosome.new(nr_states, state_table_rows_gene)
    end
  end

  def decode
    @rows_gene.decode(nr_states.value)
  end

  def mutate
    mutation = Mutation.new
    mutation.register(self.nr_states)
    mutation.register(self.rows_gene)

    genes = mutation.execute
    Chromosome.new(*genes)
  end

  def ==(other)
    self.class == other.class &&
        @nr_states==other.nr_states &&
        @rows_gene==other.rows_gene
  end

  alias_method :eql?, :==
end