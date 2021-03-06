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

  describe '#show_index_page=' do
    it 'can be created with an index page' do
      tag_type = TagType.new(name: 'Test', show_index_page: true)

      expect(tag_type).to be_valid
      expect(tag_type).to be_show_index_page
    end

    it 'can be created without an index page' do
      tag_type = TagType.new(name: 'Test', show_index_page: false)

      expect(tag_type).to be_valid
      expect(tag_type).not_to be_show_index_page
    end
  end

end
