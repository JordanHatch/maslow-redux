namespace :users do

  desc "Creates the first user in the database if none exists"
  task :create_first_user, [:name, :email, :password] => :environment do |t, args|
    name = args[:name]
    email = args[:email]
    password = args[:password]

    create_first_user(name, email, password)
  end

  def create_first_user(name, email, password)
    if [name, email, password].any?(&:blank?)
      puts "You must provide a name, email and password to create a user.\n".colorize(:red)
      return
    end

    user = User.find_or_initialize_by(email: email)
    user.assign_attributes(
      name: name,
      password: password,
      password_confirmation: password,
      permissions: [
        'signin',
        'editor',
        'admin',
      ]
    )

    action = user.new_record? ? "created" : "updated"

    if user.save
      puts "User #{action}: #{user.email}".colorize(:green)
    else
      puts "User could not be created:".colorize(:red)
      user.errors.full_messages.each do |message|
        puts "- #{message}".colorize(:red)
      end
    end
  end
end
