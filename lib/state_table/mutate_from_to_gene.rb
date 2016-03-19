require_relative 'mutate_never_gene'

class MutateFromToGene
  private
  def initialize(from, to)
    @value = from
    @mutated_value = to
  end

  public
  def mutate
    MutateNeverGene.new(@mutated_value)
  end

  def decode
    @value
  end
end