module ApplicationHelper
  def app_title
    [
      "Maslow",
      ENV['INSTANCE_NAME']
    ].reject(&:blank?).join(": ")
  end
end
