require 'rails_helper'

RSpec.describe NeedEvidenceForm do

  let(:need) { create(:need) }
  let(:evidence_type) { create(:evidence_type) }

  def build_from_params(evidence_items)
    described_class.from_params(evidence_items: evidence_items)
  end

  describe '.from_params' do
    it 'can parse an evidence item for a need' do
      form = build_from_params([
        { evidence_type_id: evidence_type.id, value: 'All the evidence' },
      ])
      item = form.evidence_items.first

      expect(form.evidence_items.size).to eq(1)

      expect(item.evidence_type_id).to eq(evidence_type.id)
      expect(item.value).to eq('All the evidence')
    end
  end

  describe '.from_model' do
    let!(:evidence_types) { create_list(:evidence_type, 5) }

    context 'when no EvidenceItem objects exist' do
      it 'creates EvidenceItem objects for each EvidenceType' do
        form = described_class.from_model(need)

        expect(form.evidence_items.size).to eq(5)
      end
    end

    context 'when existing EvidenceItem objects are present' do
      let(:value) { 'Existing evidence item' }
      let!(:evidence_item) {
        create(:evidence_item,
          evidence_type: evidence_types.first,
          need: need,
          value: value,
        )
      }

      it 'does not build EvidenceItem objects for existing types' do
        form = described_class.from_model(need)

        existing_item = form.evidence_items.find {|item|
          item.evidence_type == evidence_types.first
        }

        expect(form.evidence_items.size).to eq(5)
        expect(existing_item.value).to eq(evidence_item.value)
      end
    end
  end

  describe '#valid?' do
    context 'given valid attributes' do
      let(:form) {
        build_from_params([
          { evidence_type_id: evidence_type.id, value: 'All the evidence' },
        ])
      }

      it 'returns true' do
        expect(form).to be_valid
      end
    end

    describe 'for a quantitative field' do
      let(:quantitative_type) { create(:quantitative_evidence_type) }

      context 'given a non-numeric value' do
        let(:form) {
          build_from_params([
            { evidence_type_id: quantitative_type.id, value: 'This is a string' },
          ])
        }

        before(:each) { form.valid? }

        it 'returns false' do
          expect(form).to_not be_valid
        end

        it 'returns an error on the field' do
          expect(form.evidence_items.first.errors).to have_key(:value)
        end
      end

      context 'given a blank value' do
        let(:form) {
          build_from_params([
            { evidence_type_id: quantitative_type.id, value: '' },
          ])
        }

        it 'returns true' do
          expect(form).to be_valid
        end
      end

      context 'given valid and invalid fields' do
        let(:form) {
          build_from_params([
            { evidence_type_id: evidence_type.id, value: 'This is a valid string' },
            { evidence_type_id: quantitative_type.id, value: 'This is an invalid string' },
          ])
        }

        it 'returns false' do
          expect(form).to_not be_valid
        end
      end
    end
  end

end
