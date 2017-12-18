require 'rails_helper'

RSpec.describe NeedPerformanceController, type: :controller do

  let(:need) { create(:need) }

  describe '#show' do
    it 'assigns the need to the view' do
      get :show, params: { need_id: need.id }

      expect(controller.send(:need)).to eq(need)
    end

    it 'builds a need performance query from given parameters' do
      get :show, params: { need_id: need.id, period: :month, group: :week }

      query = controller.send(:performance_query)

      expect(query.responses).to eq(need.need_responses)
      expect(query.metric_type).to eq(:pageviews)
      expect(query.time_period).to eq(:month)
      expect(query.time_group).to eq(:week)
    end

    it 'sets query defaults when parameters are missing' do
      get :show, params: { need_id: need.id }

      query = controller.send(:performance_query)

      expect(query.time_period).to eq(:week)
      expect(query.time_group).to eq(:day)
    end

    it 'assigns a presenter to the view containing the query object' do
      get :show, params: { need_id: need.id }

      query = controller.send(:performance_query)
      presenter = controller.send(:presenter)

      expect(presenter.send(:query)).to eq(query)
    end
  end

end
