require 'rails_helper'

RSpec.describe 'managing users', type: :feature do

  def click_on_edit_for_user_in_list(name)
    row = page.find('.users table tr', text: name)
    within row do
      click_on 'edit'
    end
  end

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

    click_on_edit_for_user_in_list(user.name)

    fill_in 'Name', with: 'Agatha Christie'

    click_on 'Update User'

    expect(page).to have_content('has been updated')

    within '.users table' do
      expect(page).to have_content('Agatha Christie')
    end
  end

  it 'can select multiple roles' do
    user = create(:user)

    visit edit_settings_user_path(user)

    select 'admin', from: 'Roles'
    select 'commenter', from: 'Roles'

    click_on 'Update User'
    expect(page).to have_content('has been updated')

    click_on_edit_for_user_in_list(user.name)

    expect(page).to have_select('Roles', selected: ['admin', 'commenter'])
    unselect 'admin', from: 'Roles'

    click_on 'Update User'
    expect(page).to have_content('has been updated')

    click_on_edit_for_user_in_list(user.name)

    expect(page).to have_select('Roles', options: ['admin', 'commenter'],
                                         selected: ['commenter'])
  end

end
