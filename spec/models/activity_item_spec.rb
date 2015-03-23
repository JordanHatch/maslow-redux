require 'rails_helper'

RSpec.describe ActivityItem, :type => :model do

  let(:need) { create(:need) }
  let(:user) { create(:user) }

  let(:valid_attributes) {
    {
      need: need,
      user: user,
      item_type: 'note',
      data: {
        text: 'This is a note',
      },
    }
  }

  it 'is created with valid attributes' do
    activity_item = ActivityItem.new(valid_attributes)

    expect(activity_item).to be_valid

    activity_item.save

    expect(activity_item).to be_persisted
  end

  it 'is invalid without a need' do
    activity_item = ActivityItem.new(valid_attributes.merge(
      need: nil
    ))

    expect(activity_item).to_not be_valid
    expect(activity_item.errors).to have_key(:need)
  end

  it 'is invalid without a user' do
    activity_item = ActivityItem.new(valid_attributes.merge(
      user: nil
    ))

    expect(activity_item).to_not be_valid
    expect(activity_item.errors).to have_key(:user)
  end

  it 'is invalid without an item type' do
    activity_item = ActivityItem.new(valid_attributes.merge(
      item_type: nil
    ))

    expect(activity_item).to_not be_valid
    expect(activity_item.errors).to have_key(:item_type)
  end

  it 'is invalid with an unknown item type' do
    activity_item = ActivityItem.new(valid_attributes.merge(
      item_type: 'foo'
    ))

    expect(activity_item).to_not be_valid
    expect(activity_item.errors).to have_key(:item_type)
  end

  describe '#data' do
    it 'returns a hash which supports indifferent access' do
      activity_item = ActivityItem.new(valid_attributes)

      expect(activity_item.data).to have_key('text')
      expect(activity_item.data).to have_key(:text)

      expect(activity_item.data['text']).to eq('This is a note')
      expect(activity_item.data[:text]).to eq('This is a note')
    end
  end

end
