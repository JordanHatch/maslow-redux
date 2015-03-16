require 'rails_helper'

RSpec.describe NeedsController, type: :controller do

  describe '#create' do
    let(:need_attributes) { attributes_for(:need) }

    it 'redirects to the need' do
      post :create, need: need_attributes

      expect(controller).to redirect_to(action: :show, id: controller.need.id)
    end

    it 'creates a need' do
      post :create, need: need_attributes

      expect(controller.need).to be_persisted
    end

    it 'displays the form again given invalid data' do
      expect(controller.need).to receive(:valid?).and_return(false)
      post :create, need: need_attributes

      expect(controller).to render_template(:new)
    end
  end

end
