class NeedPresenter

  def initialize(need)
    @need = need
  end

  def show_proposition_statements?
    PropositionStatement.any?
  end

  def show_tags?
    TagType.any?
  end

  def show_actions?
    ! need.closed?
  end

private
  attr_reader :need

end
