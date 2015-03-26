class ApplicationController < ActionController::Base
  protect_from_forgery

  # TODO: Re-instate the authorization checks once we have added an exception for
  # the Devise controllers and assigned permissions properly to the user.
  #
  # check_authorization

  include ApplicationHelper

  before_action :authenticate_user!

  rescue_from ActionController::InvalidAuthenticityToken do
    render text: "Invalid authenticity token", status: 403
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to needs_path, alert: "You do not have permission to perform this action."
  end

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  private
    def verify_authenticity_token
      raise ActionController::InvalidAuthenticityToken unless verified_request?
    end
end
