module ApplicationHelper
  def feedback_address
    Maslow::Application.config.feedback_address
  end

  def current_user
    User.first
  end
end
