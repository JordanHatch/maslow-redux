require 'oauth2'
require 'lrucache'

class GoogleAuthenticationService

  class MissingRequestToken < StandardError; end

  def initialize(client_id:, secret_key:)
    @client_id = client_id
    @secret_key = secret_key
  end

  def authorize_url(redirect_uri)
    client.auth_code.authorize_url({
      scope: scope,
      redirect_uri: redirect_uri,
      access_type: 'offline',
      prompt: 'consent',
    })
  end

  def get_token_from_auth_code(code, redirect_uri)
    client.auth_code.get_token(code, redirect_uri: redirect_uri)
  end

  def get_token_from_refresh_token(token)
    OAuth2::AccessToken.from_hash(client, :refresh_token => token).refresh!
  end
  
  def access_token
    token_cache.fetch(:token) || request_access_token!
  end

private
  attr_reader :client_id, :secret_key

  def client
    @client ||= OAuth2::Client.new(client_id, secret_key, {
      authorize_url: 'https://accounts.google.com/o/oauth2/auth',
      token_url: 'https://accounts.google.com/o/oauth2/token'
    })
  end

  def request_access_token!
    raise MissingRequestToken unless refresh_token.present?

    token = get_token_from_refresh_token(refresh_token)
    token_cache.store(:token, token)

    token
  end

  def refresh_token
    Rails.application.config.google_refresh_token
  end

  def scope
    'https://www.googleapis.com/auth/analytics.readonly'
  end

  def token_cache
    @token_cache ||= LRUCache.new(ttl: 1.hour)
  end

end
