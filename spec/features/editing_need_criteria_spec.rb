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

  def click_edit_button(page)
    within('.box-met-when') do
      click_on 'Edit'
    end
  end

  def button_label(action)
    I18n.t(action, scope: %w[formtastic actions need_criteria])
  end

  it 'can view criteria' do
    visit need_path(need)
    expect_need_criteria_present(page, expected_criteria)
  end

  it 'can update criteria' do
    visit need_path(need)
    click_edit_button(page)

    inputs = page.all('input[type=text]')

    expect(inputs.map(&:value)).to contain_exactly(*expected_criteria)

    new_value = 'cannot do a thing'

    fill_in 'Criteria 1', with: new_value
    click_on button_label(:update)

    expected = [new_value, expected_criteria.last]
    expect_need_criteria_present(page, expected)

    click_on 'Activity'
    expect(page).to have_content('Updated Met when')
  end

  it 'can add a new criteria' do
    visit need_path(need)
    click_edit_button(page)

    click_on button_label(:save_add_more)

    inputs = page.all('input[type=text]')

    expect(inputs.size).to eq(expected_criteria.size + 1)
  end

  it 'can delete a criteria' do
    visit need_path(need)
    click_edit_button(page)

    input_container = page.all('form li').first
    within(input_container) do
      check 'Delete'
    end
    click_on button_label(:update)

    expect_need_criteria_present(page, expected_criteria.last)
  end

end
