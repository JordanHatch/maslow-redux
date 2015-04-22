require 'rails_helper'

RSpec.describe 'deciding on needs', type: :feature do

  let(:need) { create(:need) }

  it 'can mark a need as in scope' do
    visit need_path(need)

    within "li.decision_scope" do
      click_on 'Update'
    end

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

  it 'can close a need as a duplicate, and then re-open it' do
    canonical_need = create(:need)

    visit need_path(need)
    click_on 'Close as duplicate'

    fill_in 'This need is a duplicate of', with: canonical_need.id
    click_on 'Close as a duplicate'

    expect(page).to have_content('This need has been closed')
    expect(page).to have_content(canonical_need.goal)
    expect(page).to_not have_content('Decide on this need')

    click_on 'Reopen this need'

    expect(page).to_not have_content('This need has been closed')
  end

end
