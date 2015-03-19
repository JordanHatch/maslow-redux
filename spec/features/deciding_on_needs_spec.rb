require 'rails_helper'

RSpec.describe 'deciding on needs', type: :feature do

  let(:need) { create(:need) }

  it 'can mark a need as in scope' do
    visit need_path(need)

    click_on 'Decisions'
    click_on 'Is the need in scope?'

    choose 'This need is in scope'
    fill_in 'Note', with: 'This need is clearly in scope for the project'

    click_on 'Make decision'

    within '.feed' do
      expect(page).to have_content('This need is in scope')
      expect(page).to have_content('This need is clearly in scope for the project')
    end

    within '.need-status' do
      expect(page).to have_content('In scope')
    end
  end

end
