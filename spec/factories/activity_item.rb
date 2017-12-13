# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity_item do
    need
    user
    item_type 'note'
    data {
      { text: 'This is a note' }
    }

    trait :note do
      item_type 'note'
      data {
        { body: 'This is a note' }
      }
    end

    factory :note_activity_item, traits: [:note]
  end
end
