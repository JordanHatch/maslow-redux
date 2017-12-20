class NeedPerformancePoint < ApplicationRecord
  extend Enumerize

  belongs_to :need_response

  enumerize :metric_type, in: [:pageviews]

  validates :need_response, :date, :metric_type, presence: true
  validates :metric_type, uniqueness: { scope: [:need_response, :date] }

  scope :pageviews, ->{ where(metric_type: :pageviews) }

  scope :this_week, ->{ where('date >= ? AND date <= ?', 1.week.ago, Date.today) }
  scope :this_month, ->{ where('date >= ? AND date <= ?', 1.month.ago, Date.today) }
  scope :this_quarter, ->{ where('date >= ? AND date <= ?', 3.months.ago, Date.today) }

  scope :by_week, -> {
    select("DATE_TRUNC('week', date) as date, SUM(value) as value, need_response_id, metric_type")
    .group("DATE_TRUNC('week', date), need_response_id, metric_type")
  }
  scope :by_month, -> {
    select("DATE_TRUNC('month', date) as date, SUM(value) as value, need_response_id, metric_type")
    .group("DATE_TRUNC('month', date), need_response_id, metric_type")
  }

  scope :for_responses, ->(responses){ where(need_response_id: responses) }
  scope :for_metric, ->(metric){ where(metric_type: metric) }
  scope :for_date, ->(date){ where(date: date) }

  default_scope -> { order('date ASC') }

end
