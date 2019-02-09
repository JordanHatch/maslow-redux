require 'rails_helper'

RSpec.describe 'managing teams', type: :feature do

  def click_on_edit_for_team_in_list(name)
    row = page.find('.teams table tr', text: name)
    within row do
      click_on 'edit'
    end
  end

  let(:attributes) { attributes_for(:team) }
  let(:team) { create(:team) }
  let!(:users) {
    [ @user ] + create_list(:user, 3)
  }

  it 'can create a team' do
    visit settings_root_path

    click_on 'Teams'
    click_on 'Add new team'

    fill_in 'Team name', with: attributes[:name]
    fill_in 'Description', with: attributes[:description]

    click_on 'Create team'

    expect(page).to have_content('has been created')

    within '.teams table' do
      expect(page).to have_content(attributes[:name])
      expect(page).to have_content(attributes[:description])
    end
  end

  it 'can update a team' do
    team = create(:team)
    visit settings_root_path

    click_on 'Teams'

    click_on_edit_for_team_in_list(team.name)

    fill_in 'Team name', with: attributes[:name]

    click_on 'Save team'

    expect(page).to have_content('has been updated')

    within '.teams table' do
      expect(page).to have_content(attributes[:name])
    end
  end

  it 'can select multiple users' do
    visit edit_settings_team_path(team)

    select users[0].name, from: 'Team members'
    select users[1].name, from: 'Team members'

    click_on 'Save team'
    expect(page).to have_content('has been updated')

    click_on_edit_for_team_in_list(team.name)

    expect(page).to have_select('Team members', options: users.map(&:name),
                                                selected: [users[0].name, users[1].name])
    unselect users[0].name, from: 'Team members'

    click_on 'Save team'
    expect(page).to have_content('has been updated')

    click_on_edit_for_team_in_list(team.name)

    expect(page).to have_select('Team members', options: users.map(&:name),
                                                selected: [users[1].name])
  end
end
