class Settings::BotUsersController < Settings::BaseController
  def index
  end

  def create
    user.assign_attributes(bot_user_params)

    if user.save
      flash.notice = "#{user.name} has been created"
      redirect_to settings_bot_users_path
    else
      render action: :new
    end
  end

  def update
    if user.update_attributes(bot_user_params)
      flash.notice = "#{user.name} has been updated"
      redirect_to settings_bot_users_path
    else
      render action: :edit
    end
  end

private

  helper_method :users, :user

  def users
    @users ||= User.only_bots
  end

  def user
    if params.key?(:id)
      @user ||= users.find(params[:id])
    else
      @user ||= users.build(roles: ['bot'])
    end
  end

  def bot_user_params
    params.require(:user).permit(:name, :email)
  end
end
