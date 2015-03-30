require 'rails_helper'

RSpec.describe 'managing users', type: :feature do

  it 'can create a user' do
    visit settings_root_path

    click_on 'Team members'
    click_on 'Add new user'

    fill_in 'Name', with: 'Winston Smith-Churchill'
    fill_in 'Email', with: 'winston@example.org'
    fill_in 'Password*', with: 'notasecret'
    fill_in 'Password confirmation', with: 'notasecret'

    click_on 'Create User'

    expect(page).to have_content('has been created')

    within '.users table' do
      expect(page).to have_content('Winston Smith-Churchill')
      expect(page).to have_content('winston@example.org')
    end
  end

  it 'can update a user' do
    user = create(:user)
    visit settings_root_path

    click_on 'Team members'

    row = page.find('.users table tr', text: user.name)
    within row do
      click_on 'edit'
    end

    fill_in 'Name', with: 'Agatha Christie'

    click_on 'Update User'

    expect(page).to have_content('has been updated')
    
    within '.users table' do
      expect(page).to have_content('Agatha Christie')
    end
  end

end
