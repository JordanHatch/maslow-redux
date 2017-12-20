require 'rails_helper'

RSpec.describe 'Token authentication', type: :request do

  let(:bot_user) { create(:bot_user) }

  describe 'signing in with token authentication' do
    it 'can authenticate for a JSON request' do
      get needs_path(format: :json), headers: { 'X-User-Email' => bot_user.email,
                                                'X-User-Token' => bot_user.authentication_token }

      expect(response).to be_ok
    end

    it 'cannot authenticate for a HTML request' do
      get needs_path(format: :html), headers: { 'X-User-Email' => bot_user.email,
                                                'X-User-Token' => bot_user.authentication_token }

      expect(response).to_not be_ok
    end

    it 'cannot authenticate with an incorrect token' do
      get needs_path(format: :json), headers: { 'X-User-Email' => bot_user.email,
                                                'X-User-Token' => 'invalid' }

      expect(response).to_not be_ok
    end
  end

end
