FactoryGirl.define do
  factory :decision do
    need

    trait :scope do
      decision_type 'scope'
    end

    trait :completion do
      decision_type 'completion'
    end

    trait :met do
      decision_type 'met'
    end

    factory :scope_decision, traits: [:scope]
    factory :completion_decision, traits: [:completion]
    factory :met_decision, traits: [:met]
  end
end
