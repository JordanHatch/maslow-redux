FactoryBot.define do
  factory :decision do
    need
    note 'Background to the decision'
    user { create(:user) }

    trait :scope do
      decision_type 'scope'
      outcome 'in_scope'
    end

    trait :completion do
      decision_type 'completion'
      outcome 'complete'
    end

    trait :met do
      decision_type 'met'
      outcome 'met'
    end

    factory :scope_decision, traits: [:scope]
    factory :completion_decision, traits: [:completion]
    factory :met_decision, traits: [:met]
  end
end
