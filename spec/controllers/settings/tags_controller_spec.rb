require 'rails_helper'

RSpec.describe Settings::TagsController, :type => :controller do

  let(:tag_type) { create(:tag_type) }

  describe '#create' do
    let(:tag_attributes) { attributes_for(:tag) }

    it 'redirects to the tag type' do
      post :create, tag_type_id: tag_type, tag: tag_attributes

      expect(controller).to redirect_to(settings_tag_type_path(tag_type))
    end

    it 'creates a tag type' do
      post :create, tag_type_id: tag_type, tag: tag_attributes

      expect(controller.tag_instance).to be_persisted
    end

    it 'displays the form again given invalid data' do
      expect(controller.tag_instance).to receive(:valid?).and_return(false)
      post :create, tag_type_id: tag_type, tag: tag_attributes

      expect(controller).to render_template(:new)
    end
  end

  describe '#update' do
    let(:tag) { create(:tag, tag_type: tag_type) }
    let(:updated_attributes) { { name: 'Another name' } }

    it 'redirects to the tag type' do
      patch :update, id: tag, tag_type_id: tag_type, tag: updated_attributes

      expect(controller).to redirect_to(settings_tag_type_path(tag_type))
    end

    it 'updates a tag' do
      patch :update, id: tag, tag_type_id: tag_type, tag: updated_attributes

      controller.tag_instance.reload
      expect(controller.tag_instance.name).to eq('Another name')
    end

    it 'displays the form again given invalid data' do
      expect(controller.tag_instance).to receive(:valid?).and_return(false)
      patch :update, id: tag, tag_type_id: tag_type, tag: updated_attributes

      expect(controller).to render_template(:edit)
    end
  end

  describe '#destroy' do
    let(:tag) { create(:tag, tag_type: tag_type) }

    it 'destroys the tag' do
      delete :destroy, id: tag, tag_type_id: tag_type

      expect(controller.tag_instance).to be_destroyed
    end

    it 'redirects to the tag type' do
      delete :destroy, id: tag, tag_type_id: tag_type

      expect(controller).to redirect_to(settings_tag_type_path(tag_type))
    end
  end

end
