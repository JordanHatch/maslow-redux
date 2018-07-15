FactoryBot.define do
  factory :evidence_type do
    name "Legislation"
    description "What legislation underpins this need?"
    kind :qualitative

    trait :quantitative do
      kind :quantitative
    end

    factory :quantitative_evidence_type, traits: [:quantitative]
  end
end
