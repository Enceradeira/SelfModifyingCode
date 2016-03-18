require_relative 'state_transition'
require_relative 'mutation'

class StateTransitionGene
  private
  def initialize(new_symbol_gene, direction_gene, new_state_gene)
    @new_symbol_gene = new_symbol_gene
    @direction_gene = direction_gene
    @new_state_gene = new_state_gene
  end

  protected
  attr_reader :new_symbol_gene, :new_state_gene, :direction_gene

  public
  def mutate
    mutation = Mutation.new
    mutation.register(@new_symbol_gene)
    mutation.register(@direction_gene)
    mutation.register(@new_state_gene)

    mutations = mutation.execute
    self.class.new(*mutations)
  end

  def decode
    StateTransition.new(@new_symbol_gene.value, @direction_gene.value, @new_state_gene.value)
  end

  def ==(other)
    self.class == other.class &&
        @new_symbol_gene==other.new_symbol_gene &&
        @direction_gene==other.direction_gene &&
        @new_state_gene==other.new_state_gene
  end

  alias_method :eql?, :==
end