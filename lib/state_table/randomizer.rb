class Randomizer
  class << self
    def rand(max_inclusive_it)
      Random.rand(max_inclusive_it + 1)
    end
  end
end