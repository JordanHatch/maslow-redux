require 'rails_helper'

RSpec.describe NeedPerformancePresenter, type: :presenter do

  let!(:need) { create(:need) }
  let!(:response) { create(:need_response, need: need) }
  let!(:performance_points) {
    [
      create(:need_performance_point, need_response: response, date: DateTime.now.utc.to_date, value: 10),
      create(:need_performance_point, need_response: response, date: 1.day.ago, value: 20),
      create(:need_performance_point, need_response: response, date: 2.days.ago, value: 30),
    ]
  }
  let(:query) {
    NeedPerformanceQuery.new([response], metric_type: 'pageviews',
                                        time_period: :week,
                                        time_group: :day)
  }

  subject { NeedPerformancePresenter.new(query) }

  def time_format(date)
    date.strftime('%b %d, %Y')
  end

  describe '#stacked_performance' do
    it 'returns performance data in a graph-ready format' do
      output = [
          {
            name: response.name,
            data: [
              [ time_format(2.days.ago), 30 ],
              [ time_format(1.day.ago), 20 ],
              [ time_format(DateTime.now.utc.to_date), 10 ],
            ]
          }
      ]

      expect(subject.stacked_performance).to eq(output)
    end
  end

  describe '#has_data_to_display?' do
    it 'returns true when results are present' do
      expect(query).to receive(:results).and_return([1, 2, 3])

      expect(subject.has_data_to_display?).to eq(true)
    end

    it 'returns false when there are no results' do
      expect(query).to receive(:results).and_return([])

      expect(subject.has_data_to_display?).to eq(false)
    end
  end

  describe '#current_time_period' do
    it 'returns the key of the currently selected time period' do
      expect(subject.current_time_period).to eq(:week)
    end
  end

  describe '#current_time_group' do
    it 'returns the key of the currently selected time group' do
      expect(subject.current_time_group).to eq(:day)
    end
  end

  describe '#available_time_periods' do
    it 'returns the translated labels for the available time periods' do
      expect(subject.available_time_periods).to eq(
        [
          [ I18n.t('performance.graphs.time_periods.week'), :week ],
          [ I18n.t('performance.graphs.time_periods.month'), :month ],
          [ I18n.t('performance.graphs.time_periods.quarter'), :quarter ],
        ]
      )
    end
  end

  describe '#available_time_groups' do
    it 'returns the translated labels for the available time groups' do
      expect(subject.available_time_groups).to eq(
        [
          [ I18n.t('performance.graphs.time_groups.day'), :day ],
          [ I18n.t('performance.graphs.time_groups.week'), :week ],
          [ I18n.t('performance.graphs.time_groups.month'), :month ],
        ]
      )
    end
  end

end
