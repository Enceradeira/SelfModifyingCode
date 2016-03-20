class Mutation
  private
  def initialize
    @subjects = []
  end

  public
  def register(mutation_subject)
    @subjects << mutation_subject
  end

  def execute(vocabulary)
    subject_to_be_mutated = @subjects.sample
    @subjects.map do |subject|
      if subject == subject_to_be_mutated
        subject.mutate(vocabulary)
      else
        subject
      end
    end
  end
end