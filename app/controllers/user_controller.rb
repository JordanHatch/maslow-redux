class UserController < ApplicationController
  skip_authorization_check

  def update_password
    if user.update_with_password(password_params)
      # Sign the user in again, in case their password has now changed
      #
      sign_in user, bypass: true

      flash.notice = 'Password changed'
      redirect_to root_path
    else
      render action: :edit_password
    end
  end

  def user
    @user ||= current_user
  end
  helper_method :user

private

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
