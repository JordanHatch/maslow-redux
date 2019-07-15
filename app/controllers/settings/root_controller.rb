class Settings::RootController < Settings::BaseController

  def index
    redirect_to settings_evidence_types_path
  end

end
