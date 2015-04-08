class Settings::BaseController < ApplicationController
  layout 'settings/layouts/settings'
  before_filter :authorize_settings_access

  expose(:tag_types)

private
  def authorize_settings_access
    authorize! :manage, :settings
  end
end
