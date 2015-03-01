module ApplicationHelper
  def current_user
    @user ||= User.first
  end
end
