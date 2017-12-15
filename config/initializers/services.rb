Maslow::Application.configure do
  config.google_authentication_service = GoogleAuthenticationService.new(
    client_id: ENV['GOOGLE_OAUTH_CLIENT_ID'],
    secret_key: ENV['GOOGLE_OAUTH_SECRET_KEY'],
  )
  config.google_refresh_token = ENV['GOOGLE_OAUTH_REFRESH_TOKEN']

  config.google_analytics_view_id = ENV['GOOGLE_ANALYTICS_VIEW_ID']
end
