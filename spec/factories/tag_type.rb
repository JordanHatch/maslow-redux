FactoryBot.define do

  factory :tag_type do
    name { 'Organisations' }

    trait :with_index_pages do
      show_index_page { true }
    end

    factory :tag_type_with_index_pages, traits: [:with_index_pages]
  end

end
