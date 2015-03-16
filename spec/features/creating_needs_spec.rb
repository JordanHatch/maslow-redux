require 'rails_helper'

RSpec.describe 'creating needs', type: :feature do

  it 'can create a need' do
    visit '/needs'
    click_on 'Add user need'

    fill_in 'As a',      with: 'Capybara'
    fill_in 'I need to', with: 'create a user need'
    fill_in 'So that',   with: 'I can check that this works'

    fill_in 'criteria-0', with: 'the assertions are met'
    click_on 'Enter another criteria'
    fill_in 'criteria-1', with: 'the test passes'
    click_on 'Enter another criteria'
    fill_in 'criteria-2', with: 'the build succeeds'

    first(:button, "Save").click

    within '.the-need' do
      expect(page).to have_content('As a Capybara')
      expect(page).to have_content('I need to create a user need')
      expect(page).to have_content('So that I can check that this works')
    end

    within '.met-when' do
      expect(page).to have_content('the assertions are met')
      expect(page).to have_content('the test passes')
      expect(page).to have_content('the build succeeds')
    end
  end

end
