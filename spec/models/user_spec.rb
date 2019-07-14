require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user) { create(:user) }
  let(:valid_attributes){
    {
      name: 'Winston Smith-Churchill',
      email: 'winston.smith.churchill@example.org',
      password: 'not a secret',
      password_confirmation: 'not a secret',
    }
  }

  it 'can be created with a name, email and confirmed password' do
    user = User.new(valid_attributes)
    expect(user).to be_valid

    user.save
    expect(user).to be_persisted
  end

  it 'is invalid without a name' do
    user = User.new(valid_attributes.merge(name: ''))

    expect(user).to_not be_valid
    expect(user.errors).to have_key(:name)
  end

  it 'is invalid without an email' do
    user = User.new(valid_attributes.merge(email: ''))

    expect(user).to_not be_valid
    expect(user.errors).to have_key(:email)
  end

  it 'is invalid without a password' do
    user = User.new(valid_attributes.merge(password: nil))

    expect(user).to_not be_valid
    expect(user.errors).to have_key(:password)
  end

  it 'is invalid with a password shorter than 8 characters' do
    user = User.new(valid_attributes.merge(password: '12345'))

    expect(user).to_not be_valid
    expect(user.errors).to have_key(:password)
  end

  it 'is invalid when the password_confirmation does not match the password' do
    user = User.new(valid_attributes.merge(
                      password: '12345678',
                      password_confirmation: '87654321',
                    ))

    expect(user).to_not be_valid
    expect(user.errors).to have_key(:password_confirmation)
  end

  describe 'roles' do
    it 'is created with no roles by default' do
      user = User.new(valid_attributes)

      expect(user.roles).to be_empty
    end

    it 'is valid with a known role' do
      user = User.new(valid_attributes.merge(roles: ['admin']))

      expect(user).to be_valid
    end

    it 'is invalid with an unknown role' do
      user = User.new(valid_attributes.merge(roles: ['foo']))

      expect(user).to_not be_valid
      expect(user.errors).to have_key(:roles)
    end

    it 'strips away empty values in the roles array' do
      user = User.new(valid_attributes.merge(roles: ['admin', '', nil]))
      user.save!

      expect(user.roles).to contain_exactly('admin')
    end
  end

  describe '#admin?' do
    it 'returns true when the user has the admin role' do
      user = User.new(valid_attributes.merge(roles: ['admin']))

      expect(user).to be_admin
    end

    it 'returns false when the user does not have the admin role' do
      user = User.new(valid_attributes.merge(roles: ['commenter']))

      expect(user).to_not be_admin
    end
  end

  describe '#editor?' do
    it 'returns true when the user has the editor role' do
      user = User.new(valid_attributes.merge(roles: ['editor']))

      expect(user).to be_editor
    end

    it 'returns false when the user does not have the editor role' do
      user = User.new(valid_attributes.merge(roles: ['admin']))

      expect(user).to_not be_editor
    end
  end

  describe '#bot?' do
    it 'returns true when the user has the bot role' do
      user = User.new(valid_attributes.merge(roles: ['bot']))

      expect(user).to be_bot
    end

    it 'returns false when the user does not have the bot role' do
      user = User.new(valid_attributes.merge(roles: ['commenter']))

      expect(user).to_not be_bot
    end
  end

  describe '#commenter?' do
    it 'returns true when the user has the commenter role' do
      user = User.new(valid_attributes.merge(roles: ['commenter']))

      expect(user).to be_commenter
    end

    it 'returns false when the user does not have the commenter role' do
      user = User.new(valid_attributes.merge(roles: ['admin']))

      expect(user).to_not be_commenter
    end
  end

  describe '#toggle_bookmark' do
    let(:other_need_ids) {
      create_list(:need, 3).map {|need| need.id.to_s }
    }
    let(:need) { create(:need) }

    it 'appends the given need ID to the bookmarks array when not already present' do
      user.bookmarks = other_need_ids
      user.toggle_bookmark(need.id)

      expect(user.bookmarks).to contain_exactly(*other_need_ids, need.id.to_s)
    end

    it 'removes the given need ID from the bookmarks array when already present' do
      user.bookmarks = [need.id] + other_need_ids
      user.toggle_bookmark(need.id)

      expect(user.bookmarks).to contain_exactly(*other_need_ids)
    end
  end

  describe '#valid_password?' do
    it 'returns false for bot users' do
      user = User.new(valid_attributes.merge(roles: ['bot', 'admin']))

      expect(user).to_not be_valid_password('not a secret')
    end

    it 'returns true for other users' do
      user = User.new(valid_attributes.merge(roles: ['commenter', 'admin']))

      expect(user).to be_valid_password('not a secret')
    end
  end

  describe '#send_reset_password_instructions' do
    # NOTE: regular behaviour of this method is tested as part of the
    # Devise gem.
    #

    it 'returns false for bot users' do
      user = User.new(valid_attributes.merge(roles: ['bot', 'admin']))

      expect(user.send_reset_password_instructions).to eq(false)
    end
  end

end
