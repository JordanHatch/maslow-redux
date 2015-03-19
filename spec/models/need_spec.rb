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

  describe 'assigning tags' do
    let(:need) { create(:need) }
    let(:tag_type) { create(:tag_type) }
    let(:tags) { create_list(:tag, 3, tag_type: tag_type) }

    it 'can assign tags by their ids' do
      need.tag_ids = tags.map(&:id)

      need.save!
      need.reload

      expect(need.taggings.size).to eq(3)
      expect(need.tags).to eq(tags)
    end

    it 'removes tags which are not included in an update' do
      need.tags = tags
      need.save!

      need.tag_ids = tags[0..1].map(&:id)
      need.save!
      need.reload

      expect(need.taggings.size).to eq(2)
      expect(need.tags).to eq(tags[0..1])
    end

    it 'can assign only the tags of a given type' do
      another_type = create(:tag_type)
      another_tag = create(:tag, tag_type: another_type)

      need.tags = [another_tag]
      need.save!

      need.set_tags_of_type(tag_type, tags)
      need.save!
      need.reload

      expect(need.taggings.size).to eq(4)
      expect(need.tags).to eq([another_tag] + tags)
    end

    it 'removes tags of the same type if they are omitted' do
      another_type = create(:tag_type)
      another_tag = create(:tag, tag_type: another_type)

      need.tags = [another_tag, tags[0]]
      need.save!

      need.set_tags_of_type(tag_type, tags[1..2])
      need.save!
      need.reload

      expect(need.taggings.size).to eq(3)
      expect(need.tags).to eq([another_tag] + tags[1..2])
    end

    it 'supports form-friendly aliases' do
      expect(need).to receive(:tag_ids_of_type).with('1')
      need.tag_ids_of_type_1

      expect(need).to receive(:set_tag_ids_of_type).with('1', [1, 2, 3])
      need.tag_ids_of_type_1 = [1, 2, 3]
    end
  end

  describe '#joined_tag_types' do
    it 'returns only one instance of each tag type' do
      tag_types = create_list(:tag_type, 2)
      tags = [
        create(:tag, tag_type: tag_types[0]),
        create(:tag, tag_type: tag_types[1]),
        create(:tag, tag_type: tag_types[1]),
      ]
      need = create(:need, tags: tags)

      expect(need.joined_tag_types).to contain_exactly(*tag_types)
    end
  end

  describe '#latest_decision' do
    let(:need) { create(:need) }

    it 'returns the most recent decision for a given type' do
      create_list(:scope_decision, 2, need: need)
      latest_decision = create(:scope_decision, need: need)

      expect(need.latest_decision(:scope)).to eq(latest_decision)
    end
  end

end
