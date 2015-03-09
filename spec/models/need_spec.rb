require 'rails_helper'

RSpec.describe Need, type: :model do

  let(:valid_attributes) {
    {
      role: 'user',
      goal: 'do a thing',
      benefit: 'I benefit from it',
      met_when: [
        'the user can do a thing',
        'the user can do another thing',
      ],
    }
  }

  it 'can be created with valid attributes' do
    need = Need.new(valid_attributes)
    expect(need).to be_valid

    need.save
    expect(need).to be_persisted
  end

end
