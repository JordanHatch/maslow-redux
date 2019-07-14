require 'rails_helper'

RSpec.describe 'setting up Maslow for the first time', { type: :feature, skip_login: true } do

  before(:each) {
    User.delete_all
  }

  context 'when a user account exists' do
    before(:each) { create(:user) }

    it 'redirects to the login page' do
      visit setup_path

      expect(page).to have_content('Sign in')
    end
  end

  context 'when no user accounts exist' do
    it 'allows creation of the first user account' do
      visit setup_path

      expect(page).to have_content('Set up Maslow')
    end
  end

end
