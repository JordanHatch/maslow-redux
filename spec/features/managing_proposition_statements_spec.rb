require 'rails_helper'

RSpec.describe 'managing proposition statements', type: :feature do

  def click_on_edit_for_statement_in_list(name)
    row = page.find('.proposition-statements table tr', text: name)
    within row do
      click_on 'edit'
    end
  end

  it 'can create a proposition statement' do
    visit settings_root_path

    click_on 'Proposition statements'
    click_on 'Add new proposition statement'

    fill_in 'Label', with: 'Official information'
    fill_in 'Short description', with: "It's official information published by the department"

    click_on 'Create'

    expect(page).to have_content('has been created')

    within 'table' do
      expect(page).to have_content('Official information')
      expect(page).to have_content("It's official information published by the department")
    end

    visit new_need_path

    within '.need-proposition-selection' do
      expect(page).to have_content('Official information')
      expect(page).to have_content("It's official information published by the department")
    end
  end

  it 'can update a proposition statement' do
    statement = create(:proposition_statement)
    visit settings_root_path

    click_on 'Proposition statements'

    click_on_edit_for_statement_in_list(statement.name)

    fill_in 'Label', with: 'Unofficial information'

    click_on 'Update'

    expect(page).to have_content('has been updated')

    within 'table' do
      expect(page).to have_content('Unofficial information')
    end

    visit new_need_path

    within '.need-proposition-selection' do
      expect(page).to have_content('Unofficial information')
    end
  end

  it 'can delete a proposition statement' do
    statement = create(:proposition_statement)
    visit settings_root_path

    click_on 'Proposition statements'

    click_on_edit_for_statement_in_list(statement.name)

    click_on 'Delete'

    expect(page).to have_content('has been deleted')

    within 'table' do
      expect(page).to_not have_content(statement.name)
    end
  end

end
