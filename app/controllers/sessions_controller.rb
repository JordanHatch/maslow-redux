class SessionsController < Devise::SessionsController
  layout 'signed_out'
end
