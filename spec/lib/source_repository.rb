class SourceRepository
  class << self
    def and
      %w(
        init,0->,r,false
        init,1->,r,undecided
        false,0->0,,accept
        false,1->0,,accept
        undecided,0->0,,accept
        undecided,1->1,,accept)
    end

    def or
      %w(
        init,0->,r,undecided
        init,1->,r,true
        true,->1,,accept
        undecided,0->0,,accept
        undecided,1->1,,accept)
    end

    def erase_tape
      %w(
        ,->,r,continue
      )
    end

    def empty
      %w()
    end

    def ambiguous_code
      %w(
        init,0->,r,accept
        init,->,,false
      )
    end

    def indefinite_recursion
      %w(
        init,->1,,false
        false,1->1,,false
      )
    end
  end
end