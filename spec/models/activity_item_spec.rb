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
        body: 'This is a note',
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

  it 'is invalid without a body when item type is a note' do
    activity_item = ActivityItem.new(valid_attributes.merge(
      item_type: 'note',
      data: {
        something_else: 'foo',
      }
    ))

    expect(activity_item).to_not be_valid
    expect(activity_item.errors).to have_key(:body)
  end

  describe '#data' do
    it 'returns a hash which supports indifferent access' do
      activity_item = ActivityItem.new(valid_attributes)

      expect(activity_item.data).to have_key('body')
      expect(activity_item.data).to have_key(:body)

      expect(activity_item.data['body']).to eq('This is a note')
      expect(activity_item.data[:body]).to eq('This is a note')
    end

    it 'returns an empty hash when empty' do
      activity_item = ActivityItem.new

      expect(activity_item.data).to eq({})
    end
  end

end
