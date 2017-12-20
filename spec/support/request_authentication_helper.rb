module RequestAuthenticationHelper
  def bot_user
    @bot_user ||= create(:bot_user)
  end

  def request_as_user(method, url, options={})
    options.merge!({
      headers: options.fetch(:headers, {}).merge(
        'X-User-Email' => bot_user.email,
        'X-User-Token' => bot_user.authentication_token,
      ),
    })

    send(method, url, options)
  end
end

RSpec.configure do |config|
  config.include RequestAuthenticationHelper, type: :request
end
