require 'rails_helper'

RSpec.describe UserController, type: :controller do

  let(:user) { @user }
  let(:attributes) {
    {
      current_password: user.password,
      password: "still not a secret",
      password_confirmation: "still not a secret",
    }
  }

  describe '#update_password' do
    it 'redirects to the root path' do
      put :update_password, user: attributes

      expect(controller).to redirect_to(root_path)
    end

    it 'updates the password of the current user' do
      expect(controller.user).to receive(:update_with_password).with(attributes)

      put :update_password, user: attributes
    end

    it 'renders the form given invalid attibutes' do
      expect(controller.user).to receive(:valid?).and_return(false)

      put :update_password, user: attributes
      expect(controller).to render_template(:edit_password)
    end
  end

end
