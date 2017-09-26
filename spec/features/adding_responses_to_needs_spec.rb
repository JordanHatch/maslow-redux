require 'rails_helper'

RSpec.describe 'adding responses to needs', type: :feature do

  let(:need) { create(:need) }

  it 'can add a response to a need' do
    visit need_responses_path(need)

    click_on 'Add new response'

    choose 'Content item'
    fill_in 'Name', with: 'Example web page'
    fill_in 'URL', with: 'http://example.org'

    click_on 'Add response'

    within '.response-list' do
      expect(page).to have_link('http://example.org')
    end

    visit activity_need_path(need)

    within '.feed' do
      expect(page).to have_content('A new content item is responding to this need')
      expect(page).to have_link('http://example.org')
    end
  end

  it 'can edit a response to a need' do
    existing_response = create(:need_response, need: need)

    visit need_responses_path(need)

    link = page.find_link(existing_response.url)
    li = link.find(:xpath, '//ancestor::li[contains(@class, "need-response-item")]')

    within li do
      click_on 'Edit'
    end

    choose 'Service'
    fill_in 'Name', with: 'Updated name'
    fill_in 'URL', with: 'http://example.org/page2'

    click_on 'Save'

    within '.response-list' do
      expect(page).to have_link('http://example.org/page2')
    end
  end

  it 'cannot add a response to a closed need' do
    closed_need = create(:closed_need)

    visit need_responses_path(closed_need)

    expect(page).to_not have_link('Add new response')

    visit new_need_response_path(closed_need)

    expect(page).to have_content('Closed needs cannot be edited')
  end

  it 'cannot edit a response to a closed need' do
    closed_need = create(:closed_need)
    existing_response = create(:need_response, need: closed_need)

    visit need_responses_path(closed_need)

    link = page.find_link(existing_response.url)
    li = link.find(:xpath, '//ancestor::li[contains(@class, "need-response-item")]')

    within li do
      expect(page).to_not have_link('Edit')
    end

    visit edit_need_response_path(closed_need, existing_response)

    expect(page).to have_content('Closed needs cannot be edited')
  end

end
