class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :text, type: String
  field :need_id, type: Integer
  field :author_id, type: String
  field :revision, type: String

  default_scope ->{ order_by([:created_at, :desc]) }

  belongs_to :author, class_name: 'User'

  validates_presence_of :text, :need_id, :author
  validate :validate_need_id

  def save
    need = Need.where(need_id: need_id).first
    self.revision = need.revisions.first.id if need
    super
  end

private

  def validate_need_id
    need = Need.where(need_id: need_id).first
    if need.nil?
      errors.add(:need_id, "A note must have a valid need_id")
    end
  end
end
