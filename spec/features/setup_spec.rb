require 'rails_helper'

RSpec.describe 'setting up Maslow for the first time', { type: :feature, skip_login: true } do

  before(:each) {
    User.delete_all
  }

  def form_label(key)
    formtastic_translation(:labels, key)
  end

  def action_label(key)
    formtastic_translation(:actions, key)
  end

  def formtastic_translation(kind, key)
    I18n.t(key, scope: [:formtastic, kind, :setup])
  end

  def setup_translation(key)
    I18n.t(key, scope: [:setup])
  end

  context 'when a user account exists' do
    before(:each) { create(:user) }

    it 'redirects to the login page' do
      visit setup_path

      expect(page).to have_content('Sign in')
    end
  end

  context 'when no user accounts exist' do
    let(:atts) { attributes_for(:user) }

    let(:name) { atts[:name] }
    let(:email) { atts[:email] }
    let(:password) { atts[:password] }

    it 'creates an admin user account and signs the user in' do
      visit setup_path

      expect(page).to have_content(setup_translation('title'))

      fill_in form_label('name'), with: name
      fill_in form_label('email'), with: email
      fill_in form_label('password'), with: password
      fill_in form_label('password_confirmation'), with: password

      click_on action_label('create')

      expect(page).to have_content(setup_translation('notices.success'))

      within '.signed-in-user' do
        expect(page).to have_content(name)
      end

      within '.nav-content' do
        expect(page).to have_link('Project settings')
      end
    end
  end

end
