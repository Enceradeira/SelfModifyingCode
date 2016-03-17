class NumericGene
  def initialize(max)
    @max = max
  end

  def value
    @value ||= Random.rand(@max + 1)
  end

  def mutate
    diff = [true, false].sample ? -1 : 1
    new_gene = NumericGene.new(Integer(@max+diff))
    if new_gene.value == value
      mutate
    else
      new_gene
    end
  end
end