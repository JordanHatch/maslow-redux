require 'rails_helper'

RSpec.describe NeedResponsesController, type: :controller do

  let(:need) { create(:need) }

  describe '#new' do
    it 'does not allow new responses to be created for closed needs' do
      closed_need = create(:closed_need)

      get :new, params: { need_id: closed_need }

      expect(controller).to redirect_to(need_responses_path(closed_need.id))
      expect(controller.flash.alert).to be_present
    end
  end

end
