require 'rails_helper'

RSpec.describe 'browsing tag pages', type: :feature do

  let!(:tag_type) { create(:tag_type_with_index_pages) }
  let!(:tag) { create(:tag, tag_type: tag_type) }
  let!(:need) { create(:need, tagged_with: tag) }

  it 'can browse to a tag page' do
    visit '/needs'

    within '.nav-content' do
      click_on tag_type.name
    end

    click_on tag.name

    within ".need-row[data-need-id=#{need.id}]" do
      expect(page).to have_content(/#{need.goal}/i)
    end
  end

  it 'can open the tag editing page' do
    # TODO: Expand this test case to edit a tag and check the changes are applied
    #
    visit tag_path(tag)
    click_on 'Edit this page'

    expect(page).to have_field('tag_body')
  end

end
