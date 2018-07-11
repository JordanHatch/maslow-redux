FactoryBot.define do
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

    trait :response_new do
      item_type 'response_new'

      transient do
        referenced_item { create(:need_response) }
      end

      data {
        {
          id: referenced_item.id,
          name: referenced_item.name,
          response_type_text: response_type_text,
          url: url,
        }
      }
    end

    factory :note_activity_item, traits: [:note]
    factory :response_new_activity_item, traits: [:response_new]
  end
end
