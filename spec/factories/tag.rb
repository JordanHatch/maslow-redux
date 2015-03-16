FactoryGirl.define do
  factory :tag do
    sequence(:name) {|n|
      "Tag #{n}"
    }
    tag_type
  end


end
