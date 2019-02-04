module Settings::TeamsHelper

  def available_users
    User.excluding_bots
  end

end
