FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Winston Smith-Churchill #{n}" }
    sequence(:email) {|n| "email-#{n}@example.org" }
  end
end
