RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller

  config.before(:each, type: :controller) do
    @user = create(:user)
    sign_in @user
  end
end
