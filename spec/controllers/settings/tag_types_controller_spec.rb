require 'rails_helper'

RSpec.describe Settings::TagTypesController, type: :controller do

  describe '#create' do
    let(:tag_type_attributes) { attributes_for(:tag_type) }

    it 'redirects to the tag type' do
      post :create, tag_type: tag_type_attributes

      expect(controller).to redirect_to(action: :show, id: controller.tag_type.id)
    end

    it 'creates a tag type' do
      post :create, tag_type: tag_type_attributes

      expect(controller.tag_type).to be_persisted
    end

    it 'displays the form again given invalid data' do
      expect(controller.tag_type).to receive(:valid?).and_return(false)
      post :create, tag_type: tag_type_attributes

      expect(controller).to render_template(:new)
    end
  end

  describe '#update' do
    let(:tag_type) { create(:tag_type) }
    let(:updated_tag_type_attributes) {
      { name: 'Orgs' }
    }

    it 'redirects to the tag type' do
      post :update, id: tag_type, tag_type: updated_tag_type_attributes

      expect(subject).to redirect_to(action: :show, id: controller.tag_type.id)
    end

    it 'updates a tag type' do
      post :update, id: tag_type, tag_type: updated_tag_type_attributes

      controller.tag_type.reload
      expect(controller.tag_type.name).to eq('Orgs')
    end

    it 'displays the form again given invalid data' do
      expect(controller.tag_type).to receive(:valid?).and_return(false)
      post :update, id: tag_type, tag_type: updated_tag_type_attributes

      expect(subject).to render_template(:edit)
    end
  end

end
