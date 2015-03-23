FactoryGirl.define do

  factory :need do
    role 'user'
    goal 'do a thing'
    benefit 'get a benefit'
    met_when [
      'the first criteria is met',
      'the second criteria is met',
    ]

    ignore do
      tagged_with false
    end

    trait :closed do
      canonical_need_id {
        create(:need).id
      }
    end

    after(:create) do |need, evaluator|
      if evaluator.tagged_with.present?
        create(:tagging, need: need, tag: evaluator.tagged_with)
      end
    end

    factory :closed_need, traits: [:closed]
  end

end
