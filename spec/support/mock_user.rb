# This ensures that the mock user exists before we run any specs. In the future,
# this will be replaced by proper authentication mocking.

RSpec.configure do |config|

  config.before(:each) do
    user = User.find_or_initialize_by(email: 'user@example.org')
    user.assign_attributes(
      name: 'Maslow User',
      permissions: [
        'signin',
        'editor',
        'admin',
      ]
    )
    user.save!
  end
  
end
