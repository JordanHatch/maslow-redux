namespace :users do

  desc "Creates or updates the mock user in the database"
  task :create_mock_user => :environment do
    user = User.find_or_initialize_by(email: 'user@example.org')
    user.assign_attributes(
      name: 'Maslow User',
      permissions: [
        'signin',
        'editor',
        'admin',
      ]
    )

    if user.new_record?
      puts "Creating a new user"
    else
      puts "Updating the existing user"
    end

    user.save!

    puts "Complete"
  end
end
