require 'rails_helper'

RSpec.describe 'signing in', type: :feature do

  let(:user) { create(:user) }
  let(:bot_user) { create(:bot_user) }

  describe 'for a signed out user', :skip_login do
    it 'can sign in as a regular user' do
      visit root_path

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_on 'Sign in'

      expect(page).to have_content('Signed in')
    end

    it 'cannot sign in with an invalid username or password' do
      visit root_path

      fill_in 'Email', with: 'foo'
      fill_in 'Password', with: 'bar'

      click_on 'Sign in'

      expect(page).to have_content('Invalid')
    end

    it 'cannot sign in as a bot user' do
      visit root_path

      fill_in 'Email', with: bot_user.email
      fill_in 'Password', with: bot_user.password

      click_on 'Sign in'

      expect(page).to have_content('Your account is not activated yet')
    end
  end

end
