class Mutation
  private
  def initialize
    @genes = []
  end

  public
  def register(gene)
    @genes << gene
  end

  def execute
    gene_to_be_mutated = @genes.sample
    @genes.map do |gene|
      if gene == gene_to_be_mutated
        gene.mutate
      else
        gene
      end
    end
  end
end