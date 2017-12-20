require 'rails_helper'

RSpec.describe NeedPerformancePointsController, type: :controller do

  let(:need) { create(:need) }
  let(:need_response) { create(:need_response, need: need) }
  let(:performance_point) { create(:need_performance_point, need_response: need_response) }

  describe '#show' do
    it 'assigns the performance point to the view' do
      get :show, params: {
                   need_id: need.id,
                   id: need_response.id,
                   metric_type: performance_point.metric_type,
                   date: performance_point.date,
                   format: :json,
                 }

      expect(controller.send(:performance_point)).to eq(performance_point)
    end

    it 'returns an error when the requested performance point does not exist' do
      get :show, params: {
                   need_id: need.id,
                   id: need_response.id,
                   metric_type: 'foo',
                   date: Date.today,
                   format: :json,
                 }

      expect(response).to be_not_found
    end
  end

  describe '#update' do
    it 'creates a new performance point' do
      put :update, params: {
                     need_id: need.id,
                     id: need_response.id,
                     metric_type: 'pageviews',
                     date: Date.parse('2017-01-01'),
                     value: 100,
                     format: :json,
                   }
      performance_point = need_response.performance_points
                                        .for_date(Date.parse('2017-01-01'))
                                        .for_metric(:pageviews)
                                        .first

      expect(performance_point.value).to eq(100)
    end

    it 'updates an existing performance point' do
      put :update, params: {
                     need_id: need.id,
                     id: need_response.id,
                     metric_type: performance_point.metric_type,
                     date: performance_point.date,
                     value: 345,
                     format: :json,
                   }
      performance_point.reload

      expect(performance_point.value).to eq(345)
    end
  end

end
