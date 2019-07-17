require 'rails_helper'

RSpec.describe 'creating needs', type: :feature do

  let(:need) { create(:need) }

  let!(:tag_type) { create(:tag_type) }
  let!(:tags) { create_list(:tag, 5, tag_type: tag_type) }

  let!(:proposition_statements) { create_list(:proposition_statement, 3) }

  it 'can create a need' do
    visit '/needs'
    click_on 'Add user need'

    fill_in 'As a',      with: 'Capybara'
    fill_in 'I need to', with: 'create a user need'
    fill_in 'So that',   with: 'I can check that this works'

    within '.need-proposition-selection' do
      check proposition_statements.first.name
      check proposition_statements.last.name
    end

    first(:button, "Save").click

    within '.the-need' do
      expect(page).to have_content('As a Capybara')
      expect(page).to have_content('I need to create a user need')
      expect(page).to have_content('So that I can check that this works')
    end

    within '.box-proposition' do
      expect(page).to have_content(proposition_statements.first.name)
      expect(page).to have_content(proposition_statements.last.name)
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

    within '.tags-list' do
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

    within '.tags-list' do
      expect(page).to have_selector('li', text: tags[0].name)
      expect(page).to_not have_selector('li', text: tags[1].name)
      expect(page).to_not have_selector('li', text: tags[2].name)
    end
  end

end
