require 'rails_helper'

RSpec.describe 'editing need responses', type: :feature do

  let(:need) { create(:need) }

  def form_label(key)
    I18n.t("formtastic.labels.need_response.#{key}")
  end

  def type_label(key)
    I18n.t(key, scope: %w[enumerize need_response response_type])
  end

  it 'can see the count of need responses on the overview' do
    response_counts = {
      content: 3,
      service: 2,
      other: 1,
    }

    response_counts.each do |type, count|
      create_list(:need_response, count, response_type: type, need: need)
    end

    visit need_path(need)

    within '.box-responses' do
      response_counts.each do |type, count|
        label = type_label(type).downcase.pluralize(count)

        # Eg. "2 content items"
        expect(page).to have_content("#{count} #{label}")
      end
    end
  end

  it 'can add a response to a need' do
    visit need_responses_path(need)

    click_on 'Add a new thing'

    choose 'Content item'
    fill_in 'name', with: 'Example web page'
    fill_in I18n.t('formtastic.labels.need_response.url'), with: 'http://example.org'

    click_on 'Save'

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
    fill_in form_label('name'), with: 'Updated name'
    fill_in form_label('url'), with: 'http://example.org/page2'

    click_on 'Save'

    within '.response-list' do
      expect(page).to have_link('http://example.org/page2')
    end
  end

  it 'cannot add a response to a closed need' do
    closed_need = create(:closed_need)

    visit need_responses_path(closed_need)

    expect(page).to_not have_link('Add a new thing')

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
