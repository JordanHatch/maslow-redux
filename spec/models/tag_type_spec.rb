require 'rails_helper'

RSpec.describe TagType, type: :model do

  it 'can be created with a name' do
    tag_type = TagType.new(name: 'Organisations')
    expect(tag_type).to be_valid

    tag_type.save

    expect(tag_type).to be_persisted
    expect(tag_type.identifier).to eq('organisations')
  end

  it 'is invalid with a blank name' do
    tag_type = TagType.new(name: '')
    
    expect(tag_type).to_not be_valid
    expect(tag_type.errors).to have_key(:name)
  end

end
