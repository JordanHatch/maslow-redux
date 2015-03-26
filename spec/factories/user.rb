FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Winston Smith-Churchill #{n}" }
    sequence(:email) {|n| "email-#{n}@example.org" }
    password 'not a secure password'
    password_confirmation 'not a secure password'
  end
end
