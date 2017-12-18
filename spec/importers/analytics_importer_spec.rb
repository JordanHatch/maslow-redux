require 'rails_helper'

RSpec.describe AnalyticsImporter do

  let(:need_response) { create(:need_response) }

  subject { AnalyticsImporter.new }

  def stub_analytics_data_point(date:,pageviews:)
    mock_data_point = OpenStruct.new(date: date, pageviews: pageviews)
    allow(subject).to receive(:fetch_data_point)
                       .with(date, need_response)
                       .and_return(mock_data_point)

    return mock_data_point
  end

  describe 'importing analytics for a need response' do
    let(:mock_empty_data_point) { OpenStruct.new(date: 3.weeks.ago, pageviews: 0) }

    before do
      # return an empty response for all dates
      allow(subject).to receive(:fetch_data_point)
                         .with(instance_of(Date), need_response)
                         .and_return(mock_empty_data_point)
    end

    it 'creates performance data points for the need response' do
      mock_data_point = stub_analytics_data_point(date: Date.today, pageviews: 100)

      subject.run!

      data_point = need_response.performance_points.find_by_date(Date.today)

      expect(data_point.date).to eq(mock_data_point.date)
      expect(data_point.value).to eq(mock_data_point.pageviews)
      expect(data_point.metric_type).to eq(:pageviews)
    end

    it 'updates a performance point where it already exists' do
      existing_data_point = create(:need_performance_point, date: Date.today,
                                                            need_response: need_response,
                                                            value: 100)
      stub_analytics_data_point(date: Date.today, pageviews: 80)

      subject.run!
      existing_data_point.reload

      expect(existing_data_point.value).to eq(80)
    end

    it 'skips updating a performance point when it already exists and is longer than 1 week ago' do
      existing_data_point = create(:need_performance_point, date: 2.weeks.ago,
                                                            need_response: need_response,
                                                            value: 100)
      stub_analytics_data_point(date: existing_data_point.date, pageviews: 80)

      subject.run!
      existing_data_point.reload

      expect(existing_data_point.value).to eq(100)
    end
  end

  describe 'when a URL is out of scope' do
    it 'skips updating a performance point when the URL is out of scope' do
      allow(PerformanceSources::AnalyticsDataPoint).to receive(:new)
                                                        .with(anything, need_response.url)
                                                        .and_raise(PerformanceSources::AnalyticsDataPoint::URLNotInScope)
      subject.run!

      expect(need_response.performance_points.count).to eq(0)
    end
  end

end
