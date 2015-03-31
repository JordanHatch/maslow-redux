class ApplicationController < ActionController::Base
  protect_from_forgery
  force_ssl if: :ssl_enabled?

  include ApplicationHelper

  before_action :authenticate_user!
  check_authorization unless: :devise_controller?

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

  def ssl_enabled?
    ENV['FORCE_SSL'].present?
  end
end
