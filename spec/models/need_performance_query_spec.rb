require 'rails_helper'

RSpec.describe NeedPerformanceQuery, type: :model do

  let(:response) { create(:need_response) }
  let!(:performance_points) {
    [
      create(:need_performance_point, need_response: response, date: Date.parse('1 January 2018')),
      create(:need_performance_point, need_response: response, date: Date.parse('2 January 2018')),
      create(:need_performance_point, need_response: response, date: Date.parse('3 January 2018')),
    ]
  }

  describe '#results' do
    it 'returns performance points for the given response and metric, grouped by the need response' do
      # Fix the time to account for the time queries here being relative to now (eg. 1 week)
      #
      Timecop.freeze(Date.parse('3 January 2018')) do
        query = NeedPerformanceQuery.new(response, metric_type: :pageviews,
                                                   time_period: :week,
                                                   time_group: :day)

        expect(query.results.keys).to contain_exactly(response)
        expect(query.results[response].map(&:id)).to contain_exactly(*performance_points.map(&:id))
      end
    end

    it 'calls the correct scopes on the data model' do
      query = NeedPerformanceQuery.new(response, metric_type: :pageviews,
                                                 time_period: :month,
                                                 time_group: :week)

      expect(NeedPerformancePoint).to receive(:for_metric).with(:pageviews).and_call_original
      expect(NeedPerformancePoint).to receive(:for_responses).with(response).and_call_original
      expect(NeedPerformancePoint).to receive(:this_month).and_call_original
      expect(NeedPerformancePoint).to receive(:by_week).and_call_original

      query.results
    end
  end

end
