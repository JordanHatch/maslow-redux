FactoryBot.define do

  factory :need do
    role 'user'
    goal 'do a thing'
    benefit 'get a benefit'
    met_when [
      'the first criteria is met',
      'the second criteria is met',
    ]

    transient do
      tagged_with false
    end

    trait :closed do
      canonical_need_id {
        create(:need).id
      }
    end

    after(:create) do |need, evaluator|
      if evaluator.tagged_with.present?
        # Allow the value of `tagged_with` to be a single tag, or an array
        # of tags.
        #
        tags = [evaluator.tagged_with].flatten

        tags.each do |tag|
          create(:tagging, need: need, tag: tag)
        end
      end
    end

    factory :closed_need, traits: [:closed]
  end

end
