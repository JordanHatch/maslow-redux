class Settings::TeamsController < Settings::BaseController
  def index
  end

  def create
    team.assign_attributes(team_params)

    if team.save
      flash.notice = "#{team.name} has been created"
      redirect_to settings_teams_path
    else
      render action: :new
    end
  end

  def update
    if team.update_attributes(team_params)
      flash.notice = "#{team.name} has been updated"
      redirect_to settings_teams_path
    else
      render action: :edit
    end
  end

private

  helper_method :teams, :team

  def teams
    @teams ||= Team.all
  end

  def team
    if params.key?(:id)
      @team ||= teams.find(params[:id])
    else
      @team ||= teams.build
    end
  end

  def team_params
    params.require(:team).permit(:name, :description, user_ids: [])
  end
end
