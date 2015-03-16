require 'rails_helper'

RSpec.describe Tag, :type => :model do

  let(:tag_type) { create(:tag_type) }

  it 'can be created for a tag type' do
    tag = Tag.new(
      tag_type: tag_type,
      name: 'Ministry of Sound',
    )
    expect(tag).to be_valid

    tag.save
    expect(tag).to be_persisted
  end

  it 'is invalid without a name' do
    tag = Tag.new(
      tag_type: tag_type,
      name: '',
    )

    expect(tag).to_not be_valid
    expect(tag.errors).to have_key(:name)
  end

  it 'is invalid without a tag_type' do
    tag = Tag.new(
      tag_type: nil,
      name: 'Thing',
    )

    expect(tag).to_not be_valid
    expect(tag.errors).to have_key(:tag_type)
  end

end
