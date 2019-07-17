require 'rails_helper'

RSpec.describe 'editing need criteria', type: :feature do

  it 'can view criteria for a need' do
    expected_criteria = [
      'can do a thing',
      'can do something else',
    ]
    need = create(:need, met_when: expected_criteria)

    visit need_criteria_path(need)
    criteria = page.all('.need-criteria li').map(&:text)
    
    expect(criteria).to contain_exactly(*expected_criteria)
  end

end
