module Settings::UsersHelper

  def available_roles
    User::ROLES - ['bot']
  end

  def available_teams
    Team.all
  end

end
