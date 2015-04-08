class Settings::UsersController < Settings::BaseController
  expose(:users)
  expose(:user)

  def index
  end

  def create
    user.assign_attributes(creation_params)

    if user.save
      flash.notice = "#{user.name} has been created"
      redirect_to settings_users_path
    else
      render action: :new
    end
  end

  def update
    if user.update_attributes(update_params)
      flash.notice = "#{user.name} has been updated"
      redirect_to settings_users_path
    else
      render action: :edit
    end
  end

private

  def creation_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, roles: [])
  end

  def update_params
    params.require(:user).permit(:name, :email, roles: [])
  end
end
