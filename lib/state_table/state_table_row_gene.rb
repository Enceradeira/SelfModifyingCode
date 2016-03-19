require_relative 'state_table_row'
require_relative 'state_transition_gene'
require_relative 'state_input_gene'
require_relative 'mutation'
require_relative 'numeric_gene'

class StateTableRowGene
  private
  def initialize(state_input_gene, transition_gene)
    @state_input_gene = state_input_gene
    @transition_gene = transition_gene
  end

  protected
  attr_reader :state_input_gene
  attr_reader :transition_gene

  public
  class << self
    def create(vocabulary)
      tr_gene = StateTransitionGene.new(NumericGene.new(1),NumericGene.new(1),NumericGene.new(1))
      si_gene = StateInputGene.create(vocabulary)
      StateTableRowGene.new(si_gene, tr_gene)
    end
  end

  def mutate
    mutation = Mutation.new
    mutation.register(@state_input_gene)
    mutation.register(@transition_gene)

    mutations = mutation.execute
    StateTableRowGene.new(*mutations)
  end

  def decode
    StateTableRow.new(@state_input_gene.decode, @transition_gene.decode)
  end

  def ==(other)
    self.class == other.class &&
        @state_input_gene==other.state_input_gene &&
        @transition_gene==other.transition_gene
  end

  alias_method :eql?, :==
end