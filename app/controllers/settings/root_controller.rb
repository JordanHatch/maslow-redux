class Settings::RootController < Settings::BaseController

  def index
    redirect_to settings_users_path
  end

end
