class Settings::BaseController < ApplicationController
  layout 'settings/layouts/settings'
  skip_authorization_check
end