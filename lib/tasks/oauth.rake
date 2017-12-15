namespace :oauth do
  desc "Start the process to get an auth token for Google Analytics"
  task :authorize => :environment do
    url = service.authorize_url(redirect_uri)

    puts "To continue, open the following URL in your browser:\n\n\t#{url.colorize(:light_blue)}\n\n"
    puts "After authorising the app, copy the value of the '?code=' parameter from the URL into the following task:\n\n"
    puts "\tbin/rake oauth:complete[".colorize(:light_blue) + "<YOUR TOKEN>".colorize(:white) + "]\n\n".colorize(:light_blue)
  end

  task :complete, [:auth_code] => :environment do |t, args|
    auth_code = args[:auth_code]

    auth_token = service.get_token_from_auth_code(auth_code, redirect_uri)

    if auth_token.refresh_token.present?
      puts "Authorization complete.\n\nNow set this environment variable:"
      puts "\tGOOGLE_OAUTH_REFRESH_TOKEN='#{auth_token.refresh_token}'"
    else
      puts "Error. No refresh token was returned from the OAuth2 provider."
    end
  end

  def redirect_uri
    'http://localhost'
  end

  def service
    Rails.application.config.google_authentication_service
  end
end
