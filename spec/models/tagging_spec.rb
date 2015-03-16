require 'rails_helper'

RSpec.describe Tagging, :type => :model do

  let(:need) { create(:need) }
  let(:tag) { create(:tag) }

  it 'can be created with a need and a tag' do
    tagging = Tagging.new(need: need, tag: tag)
    expect(tagging).to be_valid

    tagging.save
    expect(tagging).to be_persisted
  end

  it 'is invalid without a need' do
    tagging = Tagging.new(need: nil, tag: tag)

    expect(tagging).to_not be_valid
    expect(tagging.errors).to have_key(:need)
  end

  it 'is invalid without a tag' do
    tagging = Tagging.new(need: need, tag: nil)

    expect(tagging).to_not be_valid
    expect(tagging.errors).to have_key(:tag)
  end

end
