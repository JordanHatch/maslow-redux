class SetupController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  before_action :redirect_to_root_unless_setup_enabled

  layout 'signed_out'

  def index
  end

private
  def redirect_to_root_unless_setup_enabled
    redirect_to root_path unless setup_enabled?
  end

end
