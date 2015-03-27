class PasswordsController < Devise::PasswordsController
  layout 'signed_out'
end
