FactoryBot.define do
  factory :need_performance_point do
    sequence(:date) {|n| n.days.ago }
    metric_type { :pageviews }
    value { 100 }

    need_response
  end
end
