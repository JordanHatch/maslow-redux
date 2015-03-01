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
