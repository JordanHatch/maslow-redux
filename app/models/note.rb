class Note < ActiveRecord::Base

  default_scope ->{ order('created_at desc') }

  belongs_to :need
  belongs_to :author, class_name: 'User'
  belongs_to :revision, class_name: 'NeedRevision'

  validates_presence_of :text, :need_id, :author

  def save
    need = Need.where(id: need_id).first
    self.revision_id = need.revisions.first.id if need
    super
  end
end
