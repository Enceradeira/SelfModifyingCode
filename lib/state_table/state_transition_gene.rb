require_relative 'state_transition'
require_relative 'mutation'
require_relative 'mutate_from_to_gene'

class StateTransitionGene
  private
  def initialize(new_symbol, direction, new_state)
    @new_symbol = new_symbol
    @direction = direction
    @new_state = new_state
  end

  protected
  attr_reader :new_symbol, :new_state, :direction

  public
  class << self
    def create(vocabulary)
      new_symbol = vocabulary.get_symbol_on_output
      direction = vocabulary.get_direction
      new_state = vocabulary.get_state_on_output
      StateTransitionGene.new(new_symbol, direction, new_state)
    end
  end

  def mutate(vocabulary)
    mutation = Mutation.new
    mutation.register(MutateFromToGene.new(@new_symbol, vocabulary.get_symbol_on_output(@new_symbol)))
    mutation.register(MutateFromToGene.new(@direction, vocabulary.get_direction(@direction)))
    mutation.register(MutateFromToGene.new(@new_state, vocabulary.get_state_on_output(@new_state)))

    mutations = mutation.execute(vocabulary).map { |g| g.decode }
    StateTransitionGene.new(*(mutations))
  end

  def decode
    StateTransition.new(@new_symbol, @direction, @new_state)
  end

  def ==(other)
    self.class == other.class &&
        @new_symbol==other.new_symbol &&
        @direction==other.direction &&
        @new_state==other.new_state
  end

  alias_method :eql?, :==
end