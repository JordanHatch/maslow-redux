class Settings::BaseController < ApplicationController
  layout 'settings/layouts/settings'
  before_action :authorize_settings_access

  expose :tag_types, ->{ TagType.all }

private
  def authorize_settings_access
    authorize! :manage, :settings
  end
end
