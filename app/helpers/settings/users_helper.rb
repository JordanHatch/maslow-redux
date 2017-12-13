module Settings::UsersHelper

  def available_roles
    User::ROLES - ['bot']
  end

end
