require 'rails_helper'

RSpec.describe 'managing evidence types', type: :feature do

  def click_on_edit_for_evidence_type_in_list(name)
    row = page.find('.evidence-types table tr', text: name)
    within row do
      click_on 'edit'
    end
  end

  it 'can create an evidence type' do
    attributes = build(:evidence_type)

    visit settings_root_path
    click_on 'Evidence types'
    click_on 'Add new evidence type'

    fill_in 'Name', with: attributes.name
    fill_in 'Description', with: attributes.description
    select attributes.kind_text, from: 'Kind'
    click_on 'Create'

    expect(page).to have_content('has been created')

    within 'table' do
      expect(page).to have_content(attributes.name)
      expect(page).to have_content(attributes.description)
    end
  end

  it 'can update an evidence type' do
    evidence_type = create(:evidence_type)

    visit settings_root_path
    click_on 'Evidence types'
    click_on_edit_for_evidence_type_in_list(evidence_type.name)

    fill_in 'Name', with: 'Something else'
    click_on 'Update'

    expect(page).to have_content('has been updated')

    within 'table' do
      expect(page).to have_content('Something else')
    end
  end

end
