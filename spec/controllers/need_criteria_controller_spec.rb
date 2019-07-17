require 'rails_helper'

RSpec.describe NeedCriteriaController, type: :controller do

  let(:need) { create(:need) }

  describe '#show' do
    it 'assigns the need to the view' do
      get :show, params: { need_id: need.id }
      
      expect(controller.send(:need)).to eq(need)
    end
  end

end
