FactoryBot.define do
  factory :team do
    sequence(:name) {|n| "Team #{n}" }
    description { 'An overview of the team' }
  end
end
