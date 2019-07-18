require 'rails_helper'

RSpec.describe 'bookmarking needs', type: :feature do

  let!(:needs) { create_list(:need, 3) }

  it 'can add a bookmark' do
    visit needs_path

    need_to_bookmark = page.all('.need-row').find {|row|
      row.find('.need-id').text == "##{needs.first.id}"
    }

    within need_to_bookmark do
      click_on 'Toggle bookmark'
    end

    visit bookmarks_path

    rows = page.all('.need-row')
    matches = rows.map {|row|
      row.find('.need-id').text
    }

    expect(matches).to contain_exactly("##{needs.first.id}")
  end

  it 'can remove a bookmark' do
    @user.update_attribute(:bookmarks, [needs.first.id])

    visit needs_path

    existing_bookmark = page.all('.need-row').find {|row|
      row.find('.need-id').text == "##{needs.first.id}"
    }

    within existing_bookmark do
      click_on 'Toggle bookmark'
    end

    visit bookmarks_path
    
    rows = page.all('.need-row')

    expect(rows).to be_empty
  end

end
