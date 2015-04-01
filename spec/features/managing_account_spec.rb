require 'rails_helper'

RSpec.describe 'managing a user account', type: :feature do

  let(:signed_in_user) { @user }

  it 'can change the password' do
    visit root_path
    click_on 'change password'

    fill_in 'Current password', with: signed_in_user.password
    fill_in 'New password', with: 'still not a secret'
    fill_in 'Confirm your new password', with: 'still not a secret'

    click_on 'Change password'

    expect(page).to have_content('Password changed')

    click_on 'sign out'

    fill_in 'Email', with: signed_in_user.email
    fill_in 'Password', with: 'still not a secret'

    click_on 'Sign in'

    expect(page).to have_content('Signed in successfully')
  end

end
