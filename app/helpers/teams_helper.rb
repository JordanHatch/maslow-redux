module TeamsHelper
  def team_icon(team)
    team_initials = team.name.split(' ').map(&:first)[0..1].join.upcase
    content_tag :span, team_initials, class: 'team-icon', title: team.name
  end
end
