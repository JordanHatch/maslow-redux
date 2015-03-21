FactoryGirl.define do

  factory :need do
    role 'user'
    goal 'do a thing'
    benefit 'get a benefit'
    met_when [
      'the first criteria is met',
      'the second criteria is met',
    ]

    trait :closed do
      canonical_need_id {
        create(:need).id
      }
    end

    factory :closed_need, traits: [:closed]
  end

end
