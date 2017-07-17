module ApplicationHelper
  def app_title
    [
      "Maslow",
      ENV['INSTANCE_NAME']
    ].reject(&:blank?).join(": ")
  end

  def site_name
    ENV['INSTANCE_NAME'].present? ? ENV['INSTANCE_NAME'] : 'Maslow'
  end
end
