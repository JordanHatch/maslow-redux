require 'rails_helper'

RSpec.describe 'editing need criteria', type: :feature do

  let(:expected_criteria) {
    [
      'can do a thing',
      'can do something else',
    ]
  }
  let(:need) { create(:need, met_when: expected_criteria) }

  def expect_need_criteria_present(page, expected)
    criteria = page.all('.need-criteria li').map(&:text)
    expect(criteria).to contain_exactly(*expected)
  end

  it 'can view criteria' do
    visit need_criteria_path(need)
    expect_need_criteria_present(page, expected_criteria)
  end

  it 'can update criteria' do
    visit need_criteria_path(need)
    click_on 'Edit'

    inputs = page.all('input[type=text]')

    expect(inputs.map(&:value)).to contain_exactly(*expected_criteria)

    new_value = 'cannot do a thing'

    fill_in 'Criteria 1', with: new_value
    click_on 'Save criteria'

    expected = [new_value, expected_criteria.last]
    expect_need_criteria_present(page, expected)

    click_on 'Activity'
    expect(page).to have_content('Updated Met when')
  end

  it 'can add a new criteria' do
    visit need_criteria_path(need)
    click_on 'Edit'
    click_on 'Save and add another criteria'

    inputs = page.all('input[type=text]')

    expect(inputs.size).to eq(expected_criteria.size + 1)
  end

  it 'can delete a criteria' do
    visit need_criteria_path(need)
    click_on 'Edit'

    input_container = page.all('form li').first
    within(input_container) do
      check 'Delete'
    end
    click_on 'Save criteria'

    expect_need_criteria_present(page, expected_criteria.last)
  end

end