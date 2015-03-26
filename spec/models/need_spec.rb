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

  describe '#save_as' do
    let(:need) { create(:need) }
    let(:user) { create(:user) }

    it 'saves the need' do
      expect(need).to receive(:save)

      need.save_as(user)
    end

    it 'creates an activity item with a hash of changes' do
      original_goal = need.goal
      need.goal = 'test the changes'

      expect{ need.save_as(user) }.to change{ need.activity_items.count }.by(1)

      latest_revision = need.activity_items.first

      expect(latest_revision.user).to eq(user)
      expect(latest_revision.item_type).to eq('update')

      expect(latest_revision.data[:snapshot]).to eq(need.attributes)
      expect(latest_revision.data[:changes]).to eq({
        'goal' => [original_goal, need.goal]
      })
    end

    it 'does not save a change for the "met_when" field when both previous and new values are blank' do
      need.met_when = []
      need.save!

      need.met_when = ['']
      need.save_as(user)

      latest_revision = need.activity_items.first
      expect(latest_revision.data[:changes]).to_not have_key('met_when')
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

  describe '#canonical_need' do
    let(:canonical_need) { create(:need) }
    let(:valid_attributes) { attributes_for(:need) }

    it 'can be set with a valid need ID' do
      need = Need.new(valid_attributes.merge(
        canonical_need_id: canonical_need.id
      ))
      expect(need).to be_valid

      need.save
      need.reload

      expect(need.canonical_need).to eq(canonical_need)
    end

    it 'is invalid with a need ID that does not exist' do
      need = Need.new(valid_attributes.merge(
        canonical_need_id: 1234
      ))
      expect(need).to_not be_valid
      expect(need.errors).to have_key(:canonical_need)
    end
  end

  describe '.with_tag_id' do
    let(:tag) { create(:tag) }

    it 'returns needs tagged with the given tag ID' do
      other_needs = create_list(:need, 5)

      expected_need = create(:need)
      tagging = create(:tagging, tag: tag, need: expected_need)

      results = Need.with_tag_id(tag.id)
      expect(results).to contain_exactly(*expected_need)
    end
  end

end
