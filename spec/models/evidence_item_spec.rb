require 'rails_helper'

RSpec.describe EvidenceItem, type: :model do
  describe '.of_type' do
    let(:type) { create(:evidence_type) }

    context 'when a matching evidence item exists' do
      let!(:item) { create(:evidence_item, evidence_type: type) }

      it 'returns the item' do
        expect(described_class.of_type(type)).to eq(item)
      end
    end

    context 'when no matching evidence item exists' do
      let(:result) { described_class.of_type(type) }

      it 'initializes a new item' do
        expect(result).to be_a(EvidenceItem)
        expect(result).to be_new_record
      end

      it 'is set to the requested type' do
        expect(result.evidence_type).to eq(type)
      end
    end
  end

  describe '#quantitative?' do
    subject { build_stubbed(:evidence_item, evidence_type: type) }

    context 'when the evidence type is quantitative' do
      let(:type) { build_stubbed(:quantitative_evidence_type) }

      it 'is true' do
        expect(subject).to be_quantitative
      end
    end

    context 'when the evidence type is qualitative' do
      let(:type) { build_stubbed(:qualitative_evidence_type) }

      it 'is false' do
        expect(subject).to_not be_quantitative
      end
    end
  end

  describe '#qualitative?' do
    subject { build_stubbed(:evidence_item, evidence_type: type) }

    context 'when the evidence type is qualitative' do
      let(:type) { build_stubbed(:qualitative_evidence_type) }

      it 'is true' do
        expect(subject).to be_qualitative
      end
    end

    context 'when the evidence type is quantitative' do
      let(:type) { build_stubbed(:quantitative_evidence_type) }

      it 'is false' do
        expect(subject).to_not be_qualitative
      end
    end
  end
end
