require 'rails_helper'

RSpec.describe Settings::UsersController, :type => :controller do

  describe '#create' do
    let(:user_attributes) { attributes_for(:user) }

    it 'redirects to the user list' do
      post :create, user: user_attributes

      expect(controller).to redirect_to(settings_users_path)
    end

    it 'creates a user' do
      post :create, user: user_attributes

      expect(controller.user).to be_persisted
    end

    it 'displays the form again given invalid data' do
      expect(controller.user).to receive(:valid?).and_return(false)
      post :create, user: user_attributes

      expect(controller).to render_template(:new)
    end
  end

  describe '#update' do
    let(:user) { create(:user) }
    let(:updated_attributes) { { name: 'Another name' } }

    it 'redirects to the user' do
      patch :update, id: user, user: updated_attributes

      expect(controller).to redirect_to(settings_users_path)
    end

    it 'updates a user' do
      patch :update, id: user, user: updated_attributes

      controller.user.reload
      expect(controller.user.name).to eq('Another name')
    end

    it 'displays the form again given invalid data' do
      expect(controller.user).to receive(:valid?).and_return(false)
      patch :update, id: user, user: updated_attributes

      expect(controller).to render_template(:edit)
    end
  end

end
