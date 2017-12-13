require 'rails_helper'

RSpec.describe NeedResponse, type: :model do

  let(:need) { create(:need) }
  let(:valid_attributes) {
    {
      response_type: 'content',
      name: 'How to create a need',
      url: 'https://example.org/create-a-need',
      need: need,
    }
  }

  it 'can be created with valid attributes' do
    response = NeedResponse.new(valid_attributes)

    expect(response).to be_valid

    response.save

    expect(response).to be_persisted
  end

  it 'is invalid without a need' do
    response = NeedResponse.new(valid_attributes.merge(need: nil))

    expect(response).to_not be_valid
    expect(response.errors).to have_key(:need)
  end

  it 'is invalid without a response type' do
    response = NeedResponse.new(valid_attributes.merge(response_type: ''))

    expect(response).to_not be_valid
    expect(response.errors).to have_key(:response_type)
  end

  it 'is invalid with an unknown response type' do
    response = NeedResponse.new(valid_attributes.merge(response_type: 'foo'))

    expect(response).to_not be_valid
    expect(response.errors).to have_key(:response_type)
  end

  it 'is invalid without a name' do
    response = NeedResponse.new(valid_attributes.merge(name: ''))

    expect(response).to_not be_valid
    expect(response.errors).to have_key(:name)
  end

  describe '#save_as' do
    let(:user) { create(:user) }

    it 'calls `save` on the response' do
      response = create(:need_response)

      expect(response).to receive(:save).and_return(true)
      response.save_as(user)
    end

    it 'creates an activity item on the need on create' do
      response = NeedResponse.new(valid_attributes)

      response.save_as(user)
      activity_item = need.activity_items.first

      expect(activity_item.item_type).to eq('response_new')
      expect(activity_item.user).to eq(user)
      expect(activity_item.data[:need_response_id]).to eq(response.id)
    end
  end

end
