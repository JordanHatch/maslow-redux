require 'ability'

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field "name",    type: String
  field "email",   type: String
  field "permissions", type: Array
  field "organisation_slug", type: String
  field "bookmarks", type: Array, default: Array.new

  delegate :can?, :cannot?, :to => :ability

  def ability
    @ability ||= Ability.new(self)
  end

  def self.find_by_uid(uid)
    where(uid: uid).first
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
    if bookmarks.include?(need_id)
      bookmarks.delete(need_id)
    else
      bookmarks << need_id
    end
  end
end
