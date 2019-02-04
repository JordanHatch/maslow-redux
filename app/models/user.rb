require 'ability'

class User < ActiveRecord::Base
  ROLES = [
    "admin",
    "commenter",
    "bot",
  ]

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable
  acts_as_token_authenticatable

  delegate :can?, :cannot?, :to => :ability

  has_and_belongs_to_many :teams

  validates :name, presence: true
  validate :roles_exist_in_list

  before_validation :remove_blank_roles

  scope :excluding_bots, -> { where.not(":role = ANY(roles)", role: 'bot') }
  scope :only_bots, -> { where(":role = ANY(roles)", role: 'bot') }

  def ability
    @ability ||= Ability.new(self)
  end

  def commenter?
    roles.include?('commenter')
  end

  def admin?
    roles.include?('admin')
  end

  def bot?
    roles.include?('bot')
  end

  def valid_password?(password)
    # Bot users are only be permitted to åuthenticate via token authentication,
    # so stubbing this method here means that they will never be permitted to
    # sign in through the standard Devise web form.
    #
    bot? ? false : super
  end

  def password_required?
    bot? ? false : super
  end

  def toggle_bookmark(need_id)
    return if need_id <= 0

    # arrays are stored as strings
    need_id_as_string = need_id.to_s

    if bookmarks.include?(need_id_as_string)
      bookmarks.delete(need_id_as_string)
    else
      bookmarks << need_id_as_string
    end
  end

  def send_reset_password_instructions
    return false if bot?
    super
  end

private

  def remove_blank_roles
    if roles
      roles.delete_if(&:blank?)
    end
  end

  def roles_exist_in_list
    if roles.reject {|role| ROLES.include?(role) }.any?
      errors.add(:roles, 'not included in the list')
    end
  end
end
