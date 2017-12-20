require 'rails_helper'

RSpec.describe 'Need performance points', type: :request do

  let(:need) { create(:need) }
  let(:need_response) { create(:need_response, need: need) }
  let(:performance_point) { create(:need_performance_point, need_response: need_response) }

  describe 'requesting a need performance point' do
    it 'returns the point details' do
      request_as_user :get, performance_point_need_response_path(need,
                                                                 need_response,
                                                                 performance_point.metric_type,
                                                                 performance_point.date,
                                                                 format: :json)

      expect(response).to be_ok

      body = JSON.parse(response.body)
      point = body['need_performance_point']

      expect(point['value']).to eq(performance_point.value.to_s)
      expect(point['date']).to eq(performance_point.date.to_s)
      expect(point['metric_type']).to eq(performance_point.metric_type)
    end

    it 'returns a 404 when a point does not exist' do
      request_as_user :get, performance_point_need_response_path(need,
                                                                 need_response,
                                                                 'kittens',
                                                                 performance_point.date,
                                                                 format: :json)

      body = JSON.parse(response.body)

      expect(response).to be_not_found
      expect(body['status']).to eq('not_found')
    end
  end

  describe 'setting the value of a need performance point' do
    it 'creates a new performance point when one does not exist for the given parameters' do
      request_as_user :put, performance_point_need_response_path(need,
                                                                 need_response,
                                                                 'pageviews',
                                                                 '2017-01-01',
                                                                 format: :json),
                            params: { value: 50 }

      expect(response).to be_ok

      body = JSON.parse(response.body)
      point = body['need_performance_point']

      expect(point['value']).to eq('50.0')

      point = need_response.performance_points.for_date(Date.parse('2017-01-01')).for_metric(:pageviews).first
      
      expect(point.value).to eq(50)
    end

    it 'updates the performance point with a new value when one already exists' do
      request_as_user :put, performance_point_need_response_path(need,
                                                                 need_response,
                                                                 performance_point.metric_type,
                                                                 performance_point.date,
                                                                 format: :json),
                            params: { value: 1234 }

      expect(response).to be_ok

      body = JSON.parse(response.body)
      point = body['need_performance_point']

      expect(point['value']).to eq('1234.0')

      performance_point.reload

      expect(performance_point.value).to eq(1234)
    end
  end

end
