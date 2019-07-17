require 'rails_helper'

RSpec.describe NeedsController, type: :controller do

  describe '#index' do
    it 'returns a list of needs' do
      needs = create_list(:need, 5)

      get :index
      expect(controller.send(:needs)).to contain_exactly(*needs)
      expect(controller.send(:needs_with_pagination)).to contain_exactly(*needs)
    end
  end

  describe '#create' do
    let(:need_attributes) { attributes_for(:need) }

    it 'redirects to the need' do
      post :create, params: { need: need_attributes }

      expect(controller).to redirect_to(action: :show, id: controller.send(:need).id)
    end

    it 'creates a need' do
      post :create, params: { need: need_attributes }

      expect(controller.send(:need)).to be_persisted
    end

    it 'displays the form again given invalid data' do
      expect(controller.send(:need)).to receive(:valid?).and_return(false)
      post :create, params: { need: need_attributes }

      expect(controller).to render_template(:new)
    end
  end

  describe '#update' do
    let(:need) { create(:need) }
    let(:updated_attributes) {
      { role: 'automated testing script' }
    }

    it 'redirects to the need' do
      patch :update, params: { id: need, need: updated_attributes }

      expect(controller).to redirect_to(action: :show, id: need.id)
    end

    it 'updates the need' do
      patch :update, params: { id: need, need: updated_attributes }

      controller.send(:need).reload
      expect(controller.send(:need).role).to eq('automated testing script')
    end

    it 'displays the form again given invalid data' do
      expect(controller.send(:need)).to receive(:valid?).and_return(false)
      patch :update, params: { id: need, need: updated_attributes }

      expect(controller).to render_template(:edit)
    end
  end

  describe '#close_as_duplicate' do
    let(:closed_need) { create(:closed_need) }

    it 'redirects to the need page if already closed' do
      get :close_as_duplicate, params: { id: closed_need }

      expect(controller).to redirect_to(action: :show, id: closed_need.id)
    end
  end

  describe '#closed' do
    let(:existing_need) { create(:need) }
    let(:need) { create(:need) }

    it 'updates the "canonical_need_id" field for a need' do
      patch :closed, params: { id: need, need: { canonical_need_id: existing_need.id } }

      controller.send(:need).reload
      expect(controller.send(:need).canonical_need_id).to eq(existing_need.id)
    end

    it 'redirects to the need' do
      patch :closed, params: { id: need, need: { canonical_need_id: existing_need.id } }

      expect(controller).to redirect_to(action: :show, id: need.id)
    end

    it 'displays the form again given invalid data' do
      expect(controller.send(:need)).to receive(:valid?).and_return(false)
      patch :closed, params: { id: need, need: { canonical_need_id: 1234 } }

      expect(controller).to render_template(:close_as_duplicate)
    end
  end

  describe '#reopen' do
    let(:closed_need) { create(:closed_need) }

    it 'clears the "canonical_need_id" field for a need' do
      delete :reopen, params: { id: closed_need }

      controller.send(:need).reload
      expect(controller.send(:need).canonical_need_id).to eq(nil)
    end

    it 'redirects to the need' do
      delete :reopen, params: { id: closed_need }

      expect(controller).to redirect_to(action: :show, id: closed_need.id)
    end
  end

end
