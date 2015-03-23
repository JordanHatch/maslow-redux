require 'rails_helper'

RSpec.describe NeedsController, type: :controller do

  describe '#index' do
    it 'filters needs by a tag given a tag_id' do
      tag = create(:tag)
      need = create(:need, tagged_with: tag)

      get :index, tag_id: tag.id
      expect(assigns(:needs)).to contain_exactly(need)
    end
  end

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

    describe 'when criteria_action is present' do
      it 'adds more criteria without saving the need' do
        post :create, criteria_action: '1',
                      need: need_attributes.merge(
                        met_when: ['the need is met']
                      )

        expect(controller.need.met_when).to eq([
          'the need is met',
          '',
        ])

        expect(controller.need).to_not be_persisted
        expect(controller).to render_template(:new)
      end

      it 'removes a particular criteria without saving the need' do
        post :create, delete_criteria: '1',
                      need: need_attributes.merge(
                        met_when: [
                          'the need is met',
                          'another criteria is met',
                          'a third criteria is met',
                        ]
                      )

        expect(controller.need.met_when).to eq([
          'the need is met',
          'a third criteria is met',
        ])

        expect(controller.need).to_not be_persisted
        expect(controller).to render_template(:new)
      end
    end
  end

  describe '#update' do
    let(:need) { create(:need) }
    let(:updated_attributes) {
      { role: 'automated testing script' }
    }

    it 'redirects to the need' do
      patch :update, id: need, need: updated_attributes

      expect(controller).to redirect_to(action: :show, id: need.id)
    end

    it 'updates the need' do
      patch :update, id: need, need: updated_attributes

      controller.need.reload
      expect(controller.need.role).to eq('automated testing script')
    end

    it 'displays the form again given invalid data' do
      expect(controller.need).to receive(:valid?).and_return(false)
      patch :update, id: need, need: updated_attributes

      expect(controller).to render_template(:edit)
    end

    describe 'when criteria_action is present' do
      it 'adds more criteria without saving the need' do
        expect(controller.need).to_not receive(:save_as)

        patch :update, id: need, criteria_action: '1',
                       need: updated_attributes.merge(
                         met_when: ['the need is met']
                       )

        expect(controller.need.met_when).to eq([
          'the need is met', '',
        ])
        expect(controller).to render_template(:edit)
      end

      it 'removes a particular criteria without saving the need' do
        expect(controller.need).to_not receive(:save_as)

        patch :update, id: need, delete_criteria: '1',
                       need: updated_attributes.merge(
                         met_when: [
                           'the need is met',
                           'another criteria is met',
                           'a third criteria is met',
                         ],
                       )

        expect(controller.need.met_when).to eq([
          'the need is met',
          'a third criteria is met',
        ])
        expect(controller).to render_template(:edit)
      end
    end
  end

  describe '#close_as_duplicate' do
    let(:closed_need) { create(:closed_need) }

    it 'redirects to the need page if already closed' do
      get :close_as_duplicate, id: closed_need

      expect(controller).to redirect_to(action: :show, id: closed_need.id)
    end
  end

  describe '#closed' do
    let(:existing_need) { create(:need) }
    let(:need) { create(:need) }

    it 'updates the "canonical_need_id" field for a need' do
      patch :closed, id: need, need: { canonical_need_id: existing_need.id }

      controller.need.reload
      expect(controller.need.canonical_need_id).to eq(existing_need.id)
    end

    it 'redirects to the need' do
      patch :closed, id: need, need: { canonical_need_id: existing_need.id }

      expect(controller).to redirect_to(action: :show, id: need.id)
    end

    it 'displays the form again given invalid data' do
      expect(controller.need).to receive(:valid?).and_return(false)
      patch :closed, id: need, need: { canonical_need_id: 1234 }

      expect(controller).to render_template(:close_as_duplicate)
    end
  end

  describe '#reopen' do
    let(:closed_need) { create(:closed_need) }

    it 'clears the "canonical_need_id" field for a need' do
      delete :reopen, id: closed_need

      controller.need.reload
      expect(controller.need.canonical_need_id).to eq(nil)
    end

    it 'redirects to the need' do
      delete :reopen, id: closed_need

      expect(controller).to redirect_to(action: :show, id: closed_need.id)
    end
  end

end
