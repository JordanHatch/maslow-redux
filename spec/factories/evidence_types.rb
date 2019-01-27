FactoryBot.define do
  factory :evidence_type do
    name { "Legislation" }
    description { "What legislation underpins this need?" }
    kind { :qualitative }

    trait :quantitative do
      kind { :quantitative }
    end

    trait :qualitative do
      kind { :qualitative }
    end

    factory :quantitative_evidence_type, traits: [:quantitative]
    factory :qualitative_evidence_type, traits: [:qualitative]
  end
end
