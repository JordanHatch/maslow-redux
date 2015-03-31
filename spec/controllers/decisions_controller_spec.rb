require 'rails_helper'

RSpec.describe DecisionsController, :type => :controller do

  let(:need) { create(:need) }
  let(:signed_in_user) { @user }

  describe '#create' do
    let(:decision_attributes) { attributes_for(:scope_decision) }

    it 'redirects to the need decisions page' do
      post :create, need_id: need, decision: decision_attributes

      expect(controller).to redirect_to(need_activity_items_path(need))
    end

    it 'creates a decision for the need' do
      post :create, need_id: need, decision: decision_attributes

      expect(controller.decision).to be_persisted
    end

    it 'assigns the current user to the decision' do
      post :create, need_id: need, decision: decision_attributes

      expect(controller.decision.user).to eq(@user)
    end

    it 'displays the form again given invalid data' do
      expect(controller.decision).to receive(:valid?).and_return(false)
      post :create, need_id: need, decision: decision_attributes

      expect(controller).to render_template(:new)
    end
  end

end
