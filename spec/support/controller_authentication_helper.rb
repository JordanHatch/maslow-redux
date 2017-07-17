RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.before(:each, type: :controller) do
    @user = create(:admin_user)
    sign_in @user
  end
end
