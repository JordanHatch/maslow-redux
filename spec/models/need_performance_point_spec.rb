require 'rails_helper'

RSpec.describe NeedPerformancePoint, type: :model do

  let(:need_response) { create(:need_response) }
  let(:valid_attributes) {
    {
      need_response: need_response,
      metric_type: :pageviews,
      date: Date.today,
      value: 100,
    }
  }

  it 'can be created with valid attributes' do
    point = NeedPerformancePoint.new(valid_attributes)

    expect(point).to be_valid

    point.save

    expect(point).to be_persisted
  end

  it 'is invalid without a need response' do
    point = NeedPerformancePoint.new(
              valid_attributes.merge(need_response: nil)
            )

    expect(point).to_not be_valid
    expect(point.errors).to have_key(:need_response)
  end

  it 'is invalid without a metric type' do
    point = NeedPerformancePoint.new(
              valid_attributes.merge(metric_type: nil)
            )

    expect(point).to_not be_valid
    expect(point.errors).to have_key(:metric_type)
  end

  it 'is invalid with an unknown metric type' do
    point = NeedPerformancePoint.new(
              valid_attributes.merge(metric_type: :plus_ones)
            )

    expect(point).to_not be_valid
    expect(point.errors).to have_key(:metric_type)
  end

  it 'is invalid without a date' do
    point = NeedPerformancePoint.new(
              valid_attributes.merge(date: nil)
            )

    expect(point).to_not be_valid
    expect(point.errors).to have_key(:date)
  end

  it 'can be valid with a nil value' do
    point = NeedPerformancePoint.new(
              valid_attributes.merge(value: nil)
            )

    expect(point).to be_valid

    point.save

    expect(point).to be_persisted
  end

  it 'is invalid when a point exists of the same type, for the same response, and the same date' do
    NeedPerformancePoint.create!(valid_attributes)

    duplicate_point = NeedPerformancePoint.new(valid_attributes)

    expect(duplicate_point).to_not be_valid
    expect(duplicate_point.errors).to have_key(:metric_type)
  end

  describe '.this_week' do
    it 'returns data points only for the previous week' do
      this_week = (1.week.ago.to_date..DateTime.now.utc.to_date).map {|date| create(:need_performance_point, date: date) }
      others = (3.weeks.ago.to_date..2.weeks.ago).map {|date| create(:need_performance_point, date: date) }
      points = NeedPerformancePoint.this_week

      expect(points).to contain_exactly(*this_week)
    end
  end

  describe '.this_month' do
    it 'returns data points only for the previous month' do
      this_month = (1.month.ago.to_date..DateTime.now.utc.to_date).map {|date| create(:need_performance_point, date: date) }
      others = (8.weeks.ago.to_date..7.weeks.ago).map {|date| create(:need_performance_point, date: date) }

      points = NeedPerformancePoint.this_month

      expect(points).to contain_exactly(*this_month)
    end
  end

  describe '.this_quarter' do
    it 'returns data points only for the previous quarter' do
      this_quarter = (3.months.ago.to_date..Date.today).step(2.weeks).map {|date| create(:need_performance_point, date: date) }
      others = (16.weeks.ago.to_date..15.weeks.ago).map {|date| create(:need_performance_point, date: date) }

      points = NeedPerformancePoint.this_quarter

      expect(points).to contain_exactly(*this_quarter)
    end
  end

  describe '.by_week' do
    it 'returns results grouped and summed by week' do
      date_range = (Time.now.beginning_of_week.to_date..Time.now.end_of_week.to_date)

      this_week = date_range.map {|date|
        create(:need_performance_point, date: date, value: 5, need_response: need_response)
      }
      total_value = date_range.count * 5

      Timecop.freeze(Time.now.end_of_week) do
        point = NeedPerformancePoint.this_week.by_week.first
        expect(point.value).to eq(total_value)
      end
    end
  end

  describe '.by_month' do
    it 'returns results grouped and summed by month' do
      date_range = (Time.now.beginning_of_month.to_date..Time.now.end_of_month.to_date)

      this_month = date_range.map {|date|
        create(:need_performance_point, date: date, value: 5, need_response: need_response)
      }
      total_value = date_range.count * 5

      Timecop.freeze(Time.now.end_of_month) do
        point = NeedPerformancePoint.this_month.by_month.first
        expect(point.value).to eq(total_value)
      end
    end
  end

end
