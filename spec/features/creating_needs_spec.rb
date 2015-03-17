require 'rails_helper'

RSpec.describe 'creating needs', type: :feature do

  let(:need) { create(:need) }

  let!(:tag_type) { create(:tag_type) }
  let!(:tags) { create_list(:tag, 5, tag_type: tag_type) }

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

  it 'can assign tags to a need' do
    visit edit_need_path(need)

    within '.tags' do
      expect(page).to have_selector('label', text: tag_type.name)

      select tags[0].name, from: tag_type.name
      select tags[1].name, from: tag_type.name
      select tags[2].name, from: tag_type.name
    end

    first(:button, "Save").click

    within '.need-tags' do
      expect(page).to have_selector('li', text: tags[0].name)
      expect(page).to have_selector('li', text: tags[1].name)
      expect(page).to have_selector('li', text: tags[2].name)
    end
  end

  it 'can remove tags from a need' do
    need = create(:need, tags: tags[0..2])

    visit edit_need_path(need)

    within '.tags' do
      expect(page).to have_selector('label', text: tag_type.name)

      unselect tags[1].name, from: tag_type.name
      unselect tags[2].name, from: tag_type.name
    end

    first(:button, "Save").click

    within '.need-tags' do
      expect(page).to have_selector('li', text: tags[0].name)
      expect(page).to_not have_selector('li', text: tags[1].name)
      expect(page).to_not have_selector('li', text: tags[2].name)
    end
  end

end
