require 'rails_helper'

RSpec.describe GoogleAuthenticationService do

  let(:mock_client) { double("OAuth2::Client") }
  let(:mock_auth_object) { double('auth_code') }

  let(:mock_client_id) { 'my-client-id' }
  let(:mock_secret_key) { 'my-secret-key' }

  let(:redirect_uri) { 'http://foo/bar' }

  subject { GoogleAuthenticationService.new(client_id: mock_client_id, secret_key: mock_secret_key) }

  before do
    allow(OAuth2::Client).to receive(:new)
                              .with(mock_client_id, mock_secret_key, anything)
                              .and_return(mock_client)
    allow(mock_client).to receive(:auth_code).and_return(mock_auth_object)
  end

  describe '#authorize_url' do
    let(:mock_authorize_url) { 'http://example.org/oauth2/authorize' }

    it 'invokes the client to request an authorization URL and returns it' do
      expect(mock_auth_object).to receive(:authorize_url)
                                  .with(hash_including(redirect_uri: redirect_uri))
                                  .and_return(mock_authorize_url)

      expect( subject.authorize_url(redirect_uri) ).to eq(mock_authorize_url)
    end
  end

  describe '#get_token_from_auth_code' do
    let(:auth_code) { 'auth-code' }
    let(:token) { 'token' }

    it 'invokes the client to request a token' do
      expect(mock_auth_object).to receive(:get_token)
                              .with(auth_code,
                                    hash_including(redirect_uri: redirect_uri))
                              .and_return(token)

      expect( subject.get_token_from_auth_code(auth_code, redirect_uri) ).to eq(token)
    end
  end

  describe '#get_token_from_refresh_token' do
    let(:mock_access_token) { double('OAuth2::AccessToken') }

    let(:refresh_token) { 'refresh-token' }
    let(:new_token) { 'new-token' }

    it 'requests a new access token using the provided refresh token' do
      expect(OAuth2::AccessToken).to receive(:from_hash)
                                     .with(mock_client, hash_including(refresh_token: refresh_token))
                                     .and_return(mock_access_token)
      expect(mock_access_token).to receive(:refresh!).and_return(new_token)

      expect(subject.get_token_from_refresh_token(refresh_token)).to eq(new_token)
    end
  end

  describe '#access_token' do
    let(:cache) { subject.send(:token_cache) }

    let(:token) { 'my-token' }
    let(:refresh_token) { 'refresh-token' }

    it 'retreives an existing access token from the cache' do
      cache.store(:token, token)

      expect(subject.access_token).to eq('my-token')
    end

    it 'requests a new access token when the cache is empty' do
      allow(subject).to receive(:refresh_token).and_return(refresh_token)
      expect(subject).to receive(:get_token_from_refresh_token).with(refresh_token).and_return(token)

      expect(subject.access_token).to eq(token)
      expect(cache.fetch(:token)).to eq(token)
    end

    it 'raises an exception when the refresh token is missing' do
      allow(subject).to receive(:refresh_token).and_return(nil)

      expect{ subject.access_token }.to raise_error(GoogleAuthenticationService::MissingRequestToken)
    end
  end

end
