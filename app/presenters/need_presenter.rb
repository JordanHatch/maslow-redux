class NeedPresenter

  def initialize(need, view_context)
    @need = need
    @view_context = view_context
  end

  def show_proposition_statements?
    PropositionStatement.any?
  end

  def show_tags?
    TagType.any?
  end

  def show_actions?
    ! need.closed? && current_user.can?(:close, Need)
  end

private
  attr_reader :need, :view_context

  def current_user
    view_context.current_user
  end

end
