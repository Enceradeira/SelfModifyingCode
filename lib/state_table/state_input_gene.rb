require_relative 'state_input'
require_relative 'mutation'
require_relative 'mutate_from_to_gene'

class StateInputGene
  private
  def initialize(state, symbol, vocabulary)
    @vocabulary = vocabulary
    @state = state
    @symbol =symbol
  end

  protected
  attr_reader :state, :symbol

  public
  class << self
    def create(vocabulary)
      @vocabulary = vocabulary
      state = vocabulary.get_state_on_input
      symbol =vocabulary.get_symbol_on_input
      StateInputGene.new(state, symbol, vocabulary)
    end
  end

  def decode
    StateInput.new(@state, @symbol)
  end

  def mutate
    mutation = Mutation.new
    mutation.register(MutateFromToGene.new(@state, @vocabulary.get_state_on_input(@state)))
    mutation.register(MutateFromToGene.new(@symbol, @vocabulary.get_symbol_on_input(@symbol)))

    mutations = mutation.execute.map { |g| g.decode }
    StateInputGene.new(*(mutations.concat([@vocabulary])))
  end

  def ==(other)
    self.class == other.class &&
        @state==other.state &&
        @symbol==other.symbol
  end

  alias_method :eql?, :==
end