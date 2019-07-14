class SetupController < ApplicationController
  class SetupNotEnabled < StandardError; end

  before_action :enforce_setup_enabled

  skip_before_action :authenticate_user!
  skip_authorization_check

  rescue_from SetupNotEnabled, with: ->{ redirect_to root_path }

  layout 'signed_out'

  def index; end

  def create
    user.assign_attributes(setup_params)
    user.roles = ['admin']

    if user.save
      sign_in(user)
      flash.notice = t('setup.notices.success')

      redirect_to root_path
    else
      render action: :index
    end
  end

private
  def enforce_setup_enabled
    raise SetupNotEnabled unless setup_enabled?
  end

  def user
    @user ||= User.new
  end
  helper_method :user

  def setup_params
    params.require(:setup).permit(:name, :email, :password, :password_confirmation)
  end
end
