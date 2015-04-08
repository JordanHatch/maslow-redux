require 'ability'

class User < ActiveRecord::Base
  ROLES = [
    "admin",
    "commenter",
  ]

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  delegate :can?, :cannot?, :to => :ability

  validates :name, presence: true
  validate :roles_exist_in_list

  before_validation :remove_blank_roles

  def ability
    @ability ||= Ability.new(self)
  end

  def commenter?
    roles.include?('commenter')
  end

  def admin?
    roles.include?('admin')
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
