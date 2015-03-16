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

end
