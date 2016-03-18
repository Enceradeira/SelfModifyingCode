require_relative 'state_input'
require_relative 'mutation'

class StateInputGene
  private
  def initialize(state_gene, symbol_gene)
    @state_gene = state_gene
    @symbol_gene = symbol_gene
  end

  protected
  attr_reader :state_gene, :symbol_gene

  public
  def decode
    StateInput.new(@state_gene.value, @symbol_gene.value)
  end

  def mutate
    mutation = Mutation.new
    mutation.register(@state_gene)
    mutation.register(@symbol_gene)

    mutations = mutation.execute
    StateInputGene.new(*mutations)
  end

  def ==(other)
    self.class == other.class &&
        @state_gene==other.state_gene &&
        @symbol_gene==other.symbol_gene
  end

  alias_method :eql?, :==
end