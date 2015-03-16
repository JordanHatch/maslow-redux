FactoryGirl.define do

  factory :need do
    role 'user'
    goal 'do a thing'
    benefit 'get a benefit'
    met_when [
      'the first criteria is met',
      'the second criteria is met',
    ]
  end

end
