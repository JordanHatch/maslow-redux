require 'rails_helper'

RSpec.describe PerformanceSources::AnalyticsDataPoint, type: :model do

  let(:base_url) { 'http://example.org/' }
  let(:url) { 'http://example.org/path' }
  let(:date) { Date.today }

  let(:mock_profile) { double('profile', attributes: { 'websiteUrl' => base_url })  }
  let(:mock_service) { double('GoogleAnalyticsService', profile: mock_profile) }

  let(:mock_query) { double('query') }
  let(:mock_result) { double('result', pageviews: 100) }
  let(:mock_results) { double('results', each: [mock_result]) }

  subject { PerformanceSources::AnalyticsDataPoint.new(date, url) }

  before do
    allow(GoogleAnalyticsService).to receive(:new).and_return(mock_service)
  end

  describe '#pageviews' do
    it 'returns the pageviews provided by the Legato report model' do
      expect(PerformanceSources::AnalyticsDataPoint::PathReport).to receive(:for_path).with('/path').and_return(mock_query)
      expect(mock_query).to receive(:results)
                            .with(mock_profile, start_date: date, end_date: date)
                            .and_return(mock_results)

      expect(subject.pageviews).to eq(100)
    end

    it 'raises an exception when the URL is not in scope of this analytics profile' do
      another_url = 'http://google.com/'

      expect { PerformanceSources::AnalyticsDataPoint.new(date, another_url) }
        .to raise_error(PerformanceSources::AnalyticsDataPoint::URLNotInScope)
    end

    it 'does not distinguish between http- and https-connections in matching' do
      another_url = 'https://example.org/'

      model = PerformanceSources::AnalyticsDataPoint.new(date, another_url)
      expect(model.url).to eq(another_url)
    end
  end

end
