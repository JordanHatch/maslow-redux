class SetupController < ApplicationController
  class SetupNotEnabled < StandardError; end

  before_action :enforce_setup_enabled
  before_action :filter_devise_flash_messages

  skip_before_action :redirect_to_setup
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

  # This filters out the standard unauthenticated flash message set by Devise
  # when the user is redirected from the root path. It doesn't make sense to
  # show it when the app is being set up for the first time.
  #
  def filter_devise_flash_messages
    flash.delete(:alert) if flash.alert == t('devise.failure.unauthenticated')
  end

  def user
    @user ||= User.new
  end
  helper_method :user

  def setup_params
    params.require(:setup).permit(:name, :email, :password, :password_confirmation)
  end
end
