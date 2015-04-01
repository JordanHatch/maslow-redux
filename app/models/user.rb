require 'ability'

class User < ActiveRecord::Base
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  delegate :can?, :cannot?, :to => :ability

  validates :name, presence: true

  def ability
    @ability ||= Ability.new(self)
  end

  def viewer?
    true
  end

  def editor?
    true
  end

  def admin?
    true
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
end
