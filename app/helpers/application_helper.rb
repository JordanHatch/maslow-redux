module ApplicationHelper
  def current_user
    @user ||= User.first
  end

  def app_title
    [
      "Maslow",
      ENV['INSTANCE_NAME']
    ].reject(&:blank?).join(": ")
  end
end
