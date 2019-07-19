require 'rails_helper'

RSpec.describe 'editing need evidence', type: :feature do

  let(:need) { create(:need) }

  let!(:qual_evidence_item ) {
    create(:qualitative_evidence_item, need: need)
  }
  let!(:quant_evidence_item ) {
    create(:quantitative_evidence_item, need: need)
  }

  let(:qual_evidence_type) { qual_evidence_item.evidence_type }
  let(:quant_evidence_type) { quant_evidence_item.evidence_type }

  def expect_qual_evidence(name:, value:)
    within '.qualitative' do
      expect(page).to have_selector('h3', text: name)
      expect(page).to have_selector('.value', text: value)
    end
  end

  def expect_quant_evidence(name:, value:)
    within '.quantitative' do
      name_el = page.find('.big-number-detail', text: name)
      el = name_el.ancestor('li')

      within el do
        expect(page).to have_selector('.big-number', text: value)
      end
    end
  end

  it 'can view evidence' do
    visit need_evidence_path(need)

    expect_qual_evidence(
      name: qual_evidence_type.name,
      value: qual_evidence_item.value
    )
    expect_quant_evidence(
      name: quant_evidence_type.name,
      value: quant_evidence_item.value
    )
  end

  it 'can update evidence' do
    visit need_evidence_path(need)
    click_on 'Add or edit evidence'

    fill_in qual_evidence_type.name, with: 'Updated qual value'
    fill_in quant_evidence_type.name, with: '12345'

    click_on 'Save evidence'

    expect_qual_evidence(
      name: qual_evidence_type.name,
      value: 'Updated qual value',
    )
    expect_quant_evidence(
      name: quant_evidence_type.name,
      value: '12345',
    )
  end

end
