require 'rails_helper'

RSpec.describe EvidenceType, type: :model do

  let(:atts) {
    {
      name: 'Example evidence',
      kind: :qualitative,
      description: 'Description text',
    }
  }

  context 'given valid attributes' do
    let(:evidence_type) { described_class.new(atts) }

    it 'is valid' do
      expect(evidence_type).to be_valid
    end

    it 'can be persisted' do
      expect(evidence_type.save).to be_truthy
      expect(evidence_type).to be_persisted
    end
  end

  context 'with an empty name' do
    let(:evidence_type) { described_class.new(atts.merge(name: nil)) }

    it 'is invalid' do
      expect(evidence_type).to_not be_valid
      expect(evidence_type.errors).to have_key(:name)
    end
  end

  context 'with an empty kind' do
    let(:evidence_type) { described_class.new(atts.merge(kind: nil)) }

    it 'is invalid' do
      expect(evidence_type).to_not be_valid
      expect(evidence_type.errors).to have_key(:kind)
    end
  end

  context 'with an invalid kind' do
    let(:evidence_type) { described_class.new(atts.merge(kind: 'something else')) }

    it 'is invalid' do
      expect(evidence_type).to_not be_valid
      expect(evidence_type.errors).to have_key(:kind)
    end
  end

end
