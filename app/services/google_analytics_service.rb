require 'legato'

class GoogleAnalyticsService

  class ProfileNotFound < StandardError; end

  def profile
    @profile ||= legato_user.profiles.find {|profile|
      profile.id == view_id
    } || raise(ProfileNotFound, view_id)
  end

  def website_url
    profile.attributes["websiteUrl"]
  end

private
  attr_reader :access_token

  def legato_user
    @legato_user ||= Legato::User.new(access_token)
  end

  def access_token
    auth_service.access_token
  end

  def auth_service
    Rails.application.config.google_authentication_service
  end

  def view_id
    Rails.application.config.google_analytics_view_id
  end

end
