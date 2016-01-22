require_relative 'program'

class ProgramFactory
  def build(spec)
    Program.new(%w(
        init,0->,r,false
        init,1->,r,undecided
        false,0->0,-,accept
        false,1->0,-,accept
        undecided,0->0,-,accept
        undecided,1->1,-,accept)).to_source
  end
end