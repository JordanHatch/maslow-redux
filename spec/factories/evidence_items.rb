FactoryBot.define do
  factory :evidence_item do
    evidence_type
    need
    value "A thing"

    trait :quantitative do
      association :evidence_type, factory: :quantitative_evidence_type
      sequence(:value)
    end

    trait :qualitative do
      association :evidence_type, factory: :qualitative_evidence_type
      sequence(:value) {|n| "Evidence #{n}" }
    end

    factory :quantitative_evidence_item, traits: [:quantitative]
    factory :qualitative_evidence_item, traits: [:qualitative]
  end
end
