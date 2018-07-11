FactoryBot.define do
  factory :need_response do
    response_type :content
    sequence(:name) {|n| "Response Link #{n}" }
    sequence(:url) {|n| "http://responses.example.org/#{n}.html" }
    
    need
  end
end
