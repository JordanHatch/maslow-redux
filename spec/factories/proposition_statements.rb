FactoryGirl.define do
  factory :proposition_statement do
    sequence(:name) {|n| "Criteria #{n}" }
    sequence(:description) {|n| "A short description about Criteria #{n}" } 
  end
end
