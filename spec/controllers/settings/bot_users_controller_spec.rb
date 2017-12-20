require 'rails_helper'

RSpec.describe Settings::BotUsersController, :type => :controller do

  describe '#create' do
    let(:user_attributes) { attributes_for(:bot_user) }

    it 'redirects to the user list' do
      post :create, params: { user: user_attributes }

      expect(controller).to redirect_to(settings_bot_users_path)
    end

    it 'creates a user' do
      post :create, params: { user: user_attributes }

      expect(controller.send(:user)).to be_persisted
    end

    it 'displays the form again given invalid data' do
      expect(controller.send(:user)).to receive(:valid?).and_return(false)
      post :create, params: { user: user_attributes }

      expect(controller).to render_template(:new)
    end
  end

  describe '#edit' do
    it 'returns a 404 error when the requested user is not a bot' do
      regular_user = create(:user)

      get :edit, params: { id: regular_user.id }

      expect { controller.send(:user) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#update' do
    let(:user) { create(:bot_user) }
    let(:updated_attributes) { { name: 'Another name' } }

    it 'redirects to the user' do
      patch :update, params: { id: user, user: updated_attributes }

      expect(controller).to redirect_to(settings_bot_users_path)
    end

    it 'updates a user' do
      patch :update, params: { id: user, user: updated_attributes }

      controller.send(:user).reload
      expect(controller.send(:user).name).to eq('Another name')
    end

    it 'displays the form again given invalid data' do
      expect(controller.send(:user)).to receive(:valid?).and_return(false)
      patch :update, params: { id: user, user: updated_attributes }

      expect(controller).to render_template(:edit)
    end
  end

end
