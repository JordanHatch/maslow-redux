FactoryBot.define do
  factory :user do
    sequence(:name) {|n| "Winston Smith-Churchill #{n}" }
    sequence(:email) {|n| "email-#{n}@example.org" }
    password { 'not a secure password' }
    password_confirmation { 'not a secure password' }
    roles { [] }

    trait :admin do
      roles {
        ['admin']
      }
    end
    trait :editor do
      roles { ['editor'] }
    end
    trait :commenter do
      roles { ['commenter'] }
    end
    trait :bot do
      roles {
        ['bot']
      }

      password { nil }
      password_confirmation { nil }
    end

    factory :admin_user, traits: [:admin]
    factory :editor_user, traits: [:editor]
    factory :commenter_user, traits: [:commenter]
    factory :bot_user, traits: [:bot]
  end
end
